# Prefix navigation through histdb, independent of zsh's in-memory history.
typeset -gi _histdb_prefix_index=-1
typeset -g _histdb_prefix _histdb_prefix_draft _histdb_prefix_buffer
typeset -gi _histdb_prefix_cursor=0

_histdb_prefix_reset() {
    _histdb_prefix_index=-1
    _histdb_prefix_buffer=''
}

_histdb_prefix_search() {
    emulate -L zsh
    local database=${HISTDB_FILE:-$HOME/.histdb/zsh-history.db}
    [[ -r $database ]] && (( $+commands[sqlite3] )) || return 0

    # Async autosuggestions change LASTWIDGET between keypresses. Keep the
    # search position unless the user edits the buffer or moves the cursor.
    if [[ $BUFFER != $_histdb_prefix_buffer ||
          $CURSOR != $_histdb_prefix_cursor ]]; then
        _histdb_prefix_index=-1
    fi
    if (( _histdb_prefix_index == -1 )); then
        _histdb_prefix_draft=$BUFFER
        _histdb_prefix_cursor=$CURSOR
        _histdb_prefix=$LBUFFER
    fi

    local -i next=$(( _histdb_prefix_index + $1 ))
    if (( next < 0 )); then
        BUFFER=$_histdb_prefix_draft
        CURSOR=$_histdb_prefix_cursor
        _histdb_prefix_index=-1
        _histdb_prefix_buffer=$BUFFER
        return 0
    fi

    local prefix=${_histdb_prefix//\'/\'\'} result
    local draft=${_histdb_prefix_draft//\'/\'\'}
    local directory=${PWD//\'/\'\'}
    # Wrapping the text preserves multiline commands and trailing newlines.
    # substr compares literally, including SQL LIKE wildcards such as % and _.
    result=$(sqlite3 -init /dev/null -readonly -batch -noheader -list \
        -cmd '.timeout 1000' "$database" "
        SELECT 'x' || commands.argv || 'x'
        FROM history JOIN commands ON history.command_id = commands.rowid
        LEFT JOIN places ON history.place_id = places.rowid
        WHERE substr(commands.argv, 1, length('$prefix')) = '$prefix'
          AND commands.argv != '$draft'
        GROUP BY commands.argv
        -- Prefer this directory; shared commands use their latest local visit.
        ORDER BY MAX(CASE WHEN places.dir = '$directory' THEN 1 ELSE 0 END) DESC,
            COALESCE(MAX(CASE WHEN places.dir = '$directory' THEN history.start_time END),
                     MAX(history.start_time)) DESC,
            COALESCE(MAX(CASE WHEN places.dir = '$directory' THEN history.rowid END),
                     MAX(history.rowid)) DESC
        LIMIT 1 OFFSET $next;
    " 2>/dev/null) || return 0
    [[ -n $result ]] || return 0

    BUFFER=${${result#x}%x}
    CURSOR=$_histdb_prefix_cursor
    _histdb_prefix_buffer=$BUFFER
    _histdb_prefix_index=$next
}

_histdb_prefix_backward() { _histdb_prefix_search 1 }
_histdb_prefix_forward() { _histdb_prefix_search -1 }
zle -N histdb-history-beginning-search-backward _histdb_prefix_backward
zle -N histdb-history-beginning-search-forward _histdb_prefix_forward

autoload -Uz add-zsh-hook
add-zsh-hook precmd _histdb_prefix_reset

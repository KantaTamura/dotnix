local wezterm = require("wezterm")
local act = wezterm.action

local Domains = {}

local function switch_workspace(window, pane, name)
    window:perform_action(act.SwitchToWorkspace {
        name = name,
        spawn = { domain = { DomainName = "main" } },
    }, pane)
end

local function select_workspace(window, pane)
    local choices = { { id = "new", label = "+ Create new workspace" } }
    for _, name in ipairs(wezterm.mux.get_workspace_names()) do
        table.insert(choices, { id = "workspace:" .. name, label = name })
    end

    window:perform_action(act.InputSelector {
        title = "Select workspace",
        fuzzy = true,
        choices = choices,
        action = wezterm.action_callback(function(selected_window, selected_pane, id)
            if not id then
                return
            end
            if id ~= "new" then
                switch_workspace(selected_window, selected_pane, id:sub(11))
                return
            end
            selected_window:perform_action(act.PromptInputLine {
                description = "Enter name for new workspace",
                action = wezterm.action_callback(function(prompt_window, prompt_pane, name)
                    if name and name:find("%S") then
                        switch_workspace(prompt_window, prompt_pane, name)
                    end
                end),
            }, selected_pane)
        end),
    }, pane)
end

local function default_workspace_is_open()
    local success, stdout, stderr = wezterm.run_child_process {
        -- The GUI exports its own socket, which takes precedence over --prefer-mux.
        "env", "WEZTERM_UNIX_SOCKET=",
        wezterm.executable_dir .. "/wezterm",
        "--config-file", wezterm.config_file,
        "cli", "--prefer-mux", "--no-auto-start",
        "list-clients", "--format", "json",
    }
    if not success then
        wezterm.log_error("Unable to check workspace clients: " .. stderr)
        return false
    end

    local parsed, clients = pcall(wezterm.json_parse, stdout)
    if not parsed or type(clients) ~= "table" then
        wezterm.log_error("Unable to parse workspace clients: " .. stdout)
        return false
    end

    local pid = wezterm.procinfo.pid()
    for _, client in ipairs(clients) do
        if client.pid ~= pid and (client.workspace == "default" or client.workspace == "") then
            return true
        end
    end
    return false
end

function Domains.setup(config)
    config.unix_domains = { { name = "main" } }
    config.default_gui_startup_args = { "connect", "main" }
    config.default_workspace = "default"

    wezterm.on("gui-attached", function(domain)
        if domain:name() ~= "main" or wezterm.mux.get_active_workspace() ~= "default" then
            return
        end
        if not default_workspace_is_open() then
            return
        end

        wezterm.GLOBAL.show_startup_workspace_selector = true
    end)

    wezterm.on("update-status", function(window, pane)
        if not wezterm.GLOBAL.show_startup_workspace_selector or window:active_workspace() ~= "default" then
            return
        end

        -- The attach progress pane can disappear before the first status update.
        local valid, domain = pcall(pane.get_domain_name, pane)
        if valid and domain == "main" then
            wezterm.GLOBAL.show_startup_workspace_selector = false
            select_workspace(window, pane)
        end
    end)
end

return Domains

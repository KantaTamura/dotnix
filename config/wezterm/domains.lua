local Domains = {}

function Domains.setup(config)
    config.unix_domains = { { name = "main" } }
    config.default_gui_startup_args = { "connect", "main" }
end

return Domains

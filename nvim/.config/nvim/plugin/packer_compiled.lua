-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/jakub/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/home/jakub/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/home/jakub/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/home/jakub/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/jakub/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["Comment.nvim"] = {
    config = { "\27LJ\2\n5\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\fComment\frequire\0" },
    loaded = true,
    path = "/home/jakub/.local/share/nvim/site/pack/packer/start/Comment.nvim",
    url = "https://github.com/numToStr/Comment.nvim"
  },
  ["alpha-nvim"] = {
    config = { "\27LJ\2\na\0\0\5\0\5\0\n6\0\0\0'\2\1\0B\0\2\0029\0\2\0006\2\0\0'\4\3\0B\2\2\0029\2\4\2B\0\2\1K\0\1\0\vconfig\27alpha.themes.dashboard\nsetup\nalpha\frequire\0" },
    loaded = true,
    path = "/home/jakub/.local/share/nvim/site/pack/packer/start/alpha-nvim",
    url = "https://github.com/goolord/alpha-nvim"
  },
  ["bufferline.nvim"] = {
    config = { "\27LJ\2\n˝\1\0\0\6\0\b\0\r6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\6\0005\3\3\0004\4\3\0005\5\4\0>\5\1\4=\4\5\3=\3\a\2B\0\2\1K\0\1\0\foptions\1\0\0\foffsets\1\0\5\rfiletype\rNvimTree\ttext\14Directory\14highlight\14Directory\15text_align\vcenter\14separator\1\1\0\3\16diagnostics\rnvim_lsp\rtab_size\3\25!diagnostics_update_in_insert\1\nsetup\15bufferline\frequire\0" },
    loaded = true,
    path = "/home/jakub/.local/share/nvim/site/pack/packer/start/bufferline.nvim",
    url = "https://github.com/akinsho/bufferline.nvim"
  },
  ["coq.artifacts"] = {
    loaded = true,
    path = "/home/jakub/.local/share/nvim/site/pack/packer/start/coq.artifacts",
    url = "https://github.com/ms-jpq/coq.artifacts"
  },
  coq_nvim = {
    config = { "\27LJ\2\nu\0\0\3\0\b\0\n6\0\0\0009\0\1\0005\1\3\0005\2\4\0=\2\5\1=\1\2\0006\0\6\0'\2\a\0B\0\2\1K\0\1\0\bcoq\frequire\vkeymap\1\0\1\17jump_to_mark\5\1\0\1\15auto_start\2\17coq_settings\6g\bvim\0" },
    loaded = true,
    path = "/home/jakub/.local/share/nvim/site/pack/packer/start/coq_nvim",
    url = "https://github.com/ms-jpq/coq_nvim"
  },
  ["gitsigns.nvim"] = {
    config = { "\27LJ\2\n6\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\rgitsigns\frequire\0" },
    loaded = true,
    path = "/home/jakub/.local/share/nvim/site/pack/packer/start/gitsigns.nvim",
    url = "https://github.com/lewis6991/gitsigns.nvim"
  },
  ["hop.nvim"] = {
    config = { "\27LJ\2\nU\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\tkeys\28etovxqpdygfblzhckisuran\nsetup\bhop\frequire\0" },
    loaded = true,
    path = "/home/jakub/.local/share/nvim/site/pack/packer/start/hop.nvim",
    url = "https://github.com/phaazon/hop.nvim"
  },
  ["lualine.nvim"] = {
    config = { "\27LJ\2\n`\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\foptions\1\0\0\1\0\1\ntheme\15tokyonight\nsetup\flualine\frequire\0" },
    loaded = true,
    path = "/home/jakub/.local/share/nvim/site/pack/packer/start/lualine.nvim",
    url = "https://github.com/nvim-lualine/lualine.nvim"
  },
  ["mason-lspconfig.nvim"] = {
    after = { "nvim-lspconfig" },
    config = { "\27LJ\2\n=\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\20mason-lspconfig\frequire\0" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/jakub/.local/share/nvim/site/pack/packer/opt/mason-lspconfig.nvim",
    url = "https://github.com/williamboman/mason-lspconfig.nvim"
  },
  ["mason.nvim"] = {
    after = { "mason-lspconfig.nvim" },
    config = { "\27LJ\2\n3\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\nmason\frequire\0" },
    loaded = true,
    only_config = true,
    path = "/home/jakub/.local/share/nvim/site/pack/packer/start/mason.nvim",
    url = "https://github.com/williamboman/mason.nvim"
  },
  ["null-ls.nvim"] = {
    config = { "\27LJ\2\n;\0\0\2\0\4\0\0066\0\0\0009\0\1\0009\0\2\0009\0\3\0B\0\1\1K\0\1\0\20formatting_sync\bbuf\blsp\bvimÓ\1\1\2\a\1\r\0\0259\2\0\0'\4\1\0B\2\2\2\15\0\2\0X\3\19Ä6\2\2\0009\2\3\0029\2\4\0025\4\5\0-\5\0\0=\5\6\4=\1\a\4B\2\2\0016\2\2\0009\2\3\0029\2\b\2'\4\t\0005\5\n\0-\6\0\0=\6\6\5=\1\a\0053\6\v\0=\6\f\5B\2\3\1K\0\1\0\2¿\rcallback\0\1\0\0\16BufWritePre\24nvim_create_autocmd\vbuffer\ngroup\1\0\0\24nvim_clear_autocmds\bapi\bvim\28textDocument/formatting\20supports_method˙\1\1\0\b\0\16\0\0286\0\0\0'\2\1\0B\0\2\0029\1\2\0006\2\3\0009\2\4\0029\2\5\2'\4\6\0004\5\0\0B\2\3\0029\3\a\0005\5\b\0003\6\t\0=\6\n\0054\6\4\0009\a\v\0019\a\f\a>\a\1\0069\a\v\0019\a\r\a>\a\2\0069\a\v\0019\a\14\a>\a\3\6=\6\15\5B\3\2\0012\0\0ÄK\0\1\0\fsources\ajq\frustfmt\vstylua\15formatting\14on_attach\0\1\0\1\ndebug\2\nsetup\18LspFormatting\24nvim_create_augroup\bapi\bvim\rbuiltins\fnull-ls\frequire\0" },
    loaded = true,
    path = "/home/jakub/.local/share/nvim/site/pack/packer/start/null-ls.nvim",
    url = "https://github.com/jose-elias-alvarez/null-ls.nvim"
  },
  ["nvim-autopairs"] = {
    config = { "\27LJ\2\n@\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\19nvim-autopairs\frequire\0" },
    loaded = true,
    path = "/home/jakub/.local/share/nvim/site/pack/packer/start/nvim-autopairs",
    url = "https://github.com/windwp/nvim-autopairs"
  },
  ["nvim-lspconfig"] = {
    config = { "\27LJ\2\ng\0\1\3\0\3\0\a9\1\0\0+\2\1\0=\2\1\0019\1\0\0+\2\1\0=\2\2\1K\0\1\0\30document_range_formatting\24document_formatting\26resolved_capabilities \2\1\0\n\0\26\0\0316\0\0\0'\2\1\0B\0\2\0029\0\2\0009\0\3\0005\2\22\0005\3\20\0005\4\5\0005\5\4\0=\5\6\0045\5\b\0005\6\a\0=\6\t\5=\5\n\0045\5\15\0006\6\v\0009\6\f\0069\6\r\6'\b\14\0+\t\2\0B\6\3\2=\6\16\5=\5\17\0045\5\18\0=\5\19\4=\4\21\3=\3\23\0023\3\24\0=\3\25\2B\0\2\1K\0\1\0\14on_attach\0\rsettings\1\0\0\bLua\1\0\0\14telemetry\1\0\1\venable\1\14workspace\flibrary\1\0\0\5\26nvim_get_runtime_file\bapi\bvim\16diagnostics\fglobals\1\0\0\1\2\0\0\bvim\fruntime\1\0\0\1\0\1\fversion\vLuaJIT\nsetup\16sumneko_lua\14lspconfig\frequire\0" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/jakub/.local/share/nvim/site/pack/packer/opt/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-tree.lua"] = {
    config = { "\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14nvim-tree\frequire\0" },
    loaded = true,
    path = "/home/jakub/.local/share/nvim/site/pack/packer/start/nvim-tree.lua",
    url = "https://github.com/kyazdani42/nvim-tree.lua"
  },
  ["nvim-treesitter"] = {
    config = { "\27LJ\2\nã\2\0\0\6\0\r\0\0176\0\0\0'\2\1\0B\0\2\0029\1\2\0005\3\3\0005\4\4\0=\4\5\0035\4\6\0005\5\a\0=\5\b\4=\4\t\0035\4\n\0005\5\v\0=\5\b\4=\4\f\3B\1\2\1K\0\1\0\vindent\1\2\0\0\tyaml\1\0\1\venable\2\14highlight\fdisable\1\2\0\0\5\1\0\2\venable\2&additional_vim_regex_highlighting\2\19ignore_install\1\2\0\0\5\1\0\2\21ensure_installed\ball\17sync_install\1\nsetup\28nvim-treesitter.configs\frequire\0" },
    loaded = true,
    path = "/home/jakub/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-ts-rainbow"] = {
    loaded = true,
    path = "/home/jakub/.local/share/nvim/site/pack/packer/start/nvim-ts-rainbow",
    url = "https://github.com/p00f/nvim-ts-rainbow"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/home/jakub/.local/share/nvim/site/pack/packer/start/nvim-web-devicons",
    url = "https://github.com/kyazdani42/nvim-web-devicons"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/jakub/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  playground = {
    loaded = true,
    path = "/home/jakub/.local/share/nvim/site/pack/packer/start/playground",
    url = "https://github.com/nvim-treesitter/playground"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/jakub/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "/home/jakub/.local/share/nvim/site/pack/packer/start/popup.nvim",
    url = "https://github.com/nvim-lua/popup.nvim"
  },
  ["rust-tools.nvim"] = {
    config = { "\27LJ\2\ng\0\1\3\0\3\0\a9\1\0\0+\2\1\0=\2\1\0019\1\0\0+\2\1\0=\2\2\1K\0\1\0\30document_range_formatting\24document_formatting\26resolved_capabilities√\2\1\0\a\0\18\0\0216\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\6\0005\3\3\0005\4\4\0=\4\5\3=\3\a\0025\3\t\0003\4\b\0=\4\n\0035\4\14\0005\5\f\0005\6\v\0=\6\r\5=\5\15\4=\4\16\3=\3\17\2B\0\2\1K\0\1\0\vserver\rsettings\18rust-analyzer\1\0\0\16checkOnSave\1\0\0\1\0\1\fcommand\vclippy\14on_attach\1\0\0\0\ntools\1\0\0\16inlay_hints\1\0\3\23other_hints_prefix\5\27parameter_hints_prefix\5\25show_parameter_hints\1\1\0\2\23hover_with_actions\2\17autoSetHints\2\nsetup\15rust-tools\frequire\0" },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/jakub/.local/share/nvim/site/pack/packer/opt/rust-tools.nvim",
    url = "https://github.com/simrat39/rust-tools.nvim"
  },
  ["telescope-media-files.nvim"] = {
    config = { "\27LJ\2\nP\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\16media_files\19load_extension\14telescope\frequire\0" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/jakub/.local/share/nvim/site/pack/packer/opt/telescope-media-files.nvim",
    url = "https://github.com/nvim-telescope/telescope-media-files.nvim"
  },
  ["telescope-project.nvim"] = {
    config = { "\27LJ\2\nL\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\fproject\19load_extension\14telescope\frequire\0" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/jakub/.local/share/nvim/site/pack/packer/opt/telescope-project.nvim",
    url = "https://github.com/nvim-telescope/telescope-project.nvim"
  },
  ["telescope.nvim"] = {
    after = { "telescope-media-files.nvim", "telescope-project.nvim" },
    config = { "\27LJ\2\n«\n\0\0\v\0M\0à\0016\0\0\0006\2\1\0'\3\2\0B\0\3\3\14\0\0\0X\2\1ÄK\0\1\0006\2\1\0'\4\3\0B\2\2\0029\3\4\0015\5D\0005\6\5\0005\a\6\0=\a\a\0065\a3\0005\b\t\0009\t\b\2=\t\n\b9\t\v\2=\t\f\b9\t\r\2=\t\14\b9\t\15\2=\t\16\b9\t\17\2=\t\18\b9\t\r\2=\t\19\b9\t\15\2=\t\20\b9\t\21\2=\t\22\b9\t\23\2=\t\24\b9\t\25\2=\t\26\b9\t\27\2=\t\28\b9\t\29\2=\t\30\b9\t\31\2=\t \b9\t!\2=\t\"\b9\t#\2=\t$\b9\t%\0029\n&\2 \t\n\t=\t'\b9\t%\0029\n(\2 \t\n\t=\t)\b9\t*\0029\n+\2 \t\n\t=\t,\b9\t-\0029\n+\2 \t\n\t=\t.\b9\t/\2=\t0\b9\t1\2=\t2\b=\b4\a5\b5\0009\t\17\2=\t6\b9\t\21\2=\t\22\b9\t\23\2=\t\24\b9\t\25\2=\t\26\b9\t\27\2=\t\28\b9\t%\0029\n&\2 \t\n\t=\t'\b9\t%\0029\n(\2 \t\n\t=\t)\b9\t*\0029\n+\2 \t\n\t=\t,\b9\t-\0029\n+\2 \t\n\t=\t.\b9\t\r\2=\t7\b9\t\15\2=\t8\b9\t9\2=\t:\b9\t;\2=\t<\b9\t=\2=\t>\b9\t\r\2=\t\19\b9\t\15\2=\t\20\b9\t9\2=\t?\b9\t=\2=\t@\b9\t\29\2=\t\30\b9\t\31\2=\t \b9\t!\2=\t\"\b9\t#\2=\t$\b9\t1\2=\tA\b=\bB\a=\aC\6=\6E\0054\6\0\0=\6F\0055\6J\0005\aH\0005\bG\0=\bI\a=\aK\6=\6L\5B\3\2\1K\0\1\0\15extensions\16media_files\1\0\0\14filetypes\1\0\1\rfind_cmd\arg\1\5\0\0\bpng\twebp\bjpg\tjpeg\fpickers\rdefaults\1\0\0\rmappings\6n\6?\6G\agg\6L\19move_to_bottom\6M\19move_to_middle\6H\16move_to_top\6k\6j\n<esc>\1\0\0\6i\1\0\0\n<C-_>\14which_key\n<C-l>\17complete_tag\n<M-q>\28send_selected_to_qflist\n<C-q>\16open_qflist\19send_to_qflist\f<S-Tab>\26move_selection_better\n<Tab>\25move_selection_worse\21toggle_selection\15<PageDown>\27results_scrolling_down\r<PageUp>\25results_scrolling_up\n<C-d>\27preview_scrolling_down\n<C-u>\25preview_scrolling_up\n<C-t>\15select_tab\n<C-v>\20select_vertical\n<C-x>\22select_horizontal\t<CR>\19select_default\t<Up>\v<Down>\n<C-c>\nclose\n<C-k>\28move_selection_previous\n<C-j>\24move_selection_next\n<C-p>\23cycle_history_prev\n<C-n>\1\0\0\23cycle_history_next\17path_display\1\2\0\0\nsmart\1\0\2\20selection_caret\tÔÅ§ \18prompt_prefix\tÔë´ \nsetup\22telescope.actions\14telescope\frequire\npcall\0" },
    loaded = true,
    only_config = true,
    path = "/home/jakub/.local/share/nvim/site/pack/packer/start/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  ["tokyonight.nvim"] = {
    loaded = true,
    path = "/home/jakub/.local/share/nvim/site/pack/packer/start/tokyonight.nvim",
    url = "https://github.com/folke/tokyonight.nvim"
  },
  ["which-key.nvim"] = {
    config = { "\27LJ\2\n \6\0\0\6\0\26\0\0316\0\0\0'\2\1\0B\0\2\0029\1\2\0B\1\1\0019\1\3\0005\3\5\0005\4\4\0=\4\6\0035\4\a\0=\4\b\0035\4\t\0=\4\n\0035\4\v\0005\5\f\0=\5\r\4=\4\14\0035\4\15\0005\5\16\0=\5\r\0045\5\17\0=\5\18\4=\4\19\0035\4\21\0005\5\20\0=\5\22\0045\5\23\0=\5\24\4=\4\25\3B\1\2\1K\0\1\0\14<leader>b\16<leader>bcr\1\3\0\0\"<cmd>BufferLineCloseRight<cr>\31Close buffers to the right\6l\1\0\0\1\3\0\0!<cmd>BufferLineCloseLeft<cr>\30Close buffers to the left\14<leader>s\6F\1\3\0\0É\1<cmd>lua require'hop'.hint_char2({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = false })<cr>\22HOP before cursor\1\3\0\0Ç\1<cmd>lua require'hop'.hint_char2({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = false })<cr>\21HOP after cursor\1\0\1\tname\16Search/Jump\14<leader>f\6f\1\3\0\0\"<cmd>Telescope find_files<cr>\14Find File\1\0\1\tname\tFile\14<leader>q\1\3\0\0\15<cmd>q<cr>\16Quit buffer\14<leader>w\1\3\0\0\15<cmd>w<cr>\16Save buffer\n<C-n>\1\0\0\1\3\0\0\28<cmd>NvimTreeToggle<CR>\25Toggle file explorer\rregister\nsetup\14which-key\frequire\0" },
    loaded = true,
    path = "/home/jakub/.local/share/nvim/site/pack/packer/start/which-key.nvim",
    url = "https://github.com/folke/which-key.nvim"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: null-ls.nvim
time([[Config for null-ls.nvim]], true)
try_loadstring("\27LJ\2\n;\0\0\2\0\4\0\0066\0\0\0009\0\1\0009\0\2\0009\0\3\0B\0\1\1K\0\1\0\20formatting_sync\bbuf\blsp\bvimÓ\1\1\2\a\1\r\0\0259\2\0\0'\4\1\0B\2\2\2\15\0\2\0X\3\19Ä6\2\2\0009\2\3\0029\2\4\0025\4\5\0-\5\0\0=\5\6\4=\1\a\4B\2\2\0016\2\2\0009\2\3\0029\2\b\2'\4\t\0005\5\n\0-\6\0\0=\6\6\5=\1\a\0053\6\v\0=\6\f\5B\2\3\1K\0\1\0\2¿\rcallback\0\1\0\0\16BufWritePre\24nvim_create_autocmd\vbuffer\ngroup\1\0\0\24nvim_clear_autocmds\bapi\bvim\28textDocument/formatting\20supports_method˙\1\1\0\b\0\16\0\0286\0\0\0'\2\1\0B\0\2\0029\1\2\0006\2\3\0009\2\4\0029\2\5\2'\4\6\0004\5\0\0B\2\3\0029\3\a\0005\5\b\0003\6\t\0=\6\n\0054\6\4\0009\a\v\0019\a\f\a>\a\1\0069\a\v\0019\a\r\a>\a\2\0069\a\v\0019\a\14\a>\a\3\6=\6\15\5B\3\2\0012\0\0ÄK\0\1\0\fsources\ajq\frustfmt\vstylua\15formatting\14on_attach\0\1\0\1\ndebug\2\nsetup\18LspFormatting\24nvim_create_augroup\bapi\bvim\rbuiltins\fnull-ls\frequire\0", "config", "null-ls.nvim")
time([[Config for null-ls.nvim]], false)
-- Config for: lualine.nvim
time([[Config for lualine.nvim]], true)
try_loadstring("\27LJ\2\n`\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\foptions\1\0\0\1\0\1\ntheme\15tokyonight\nsetup\flualine\frequire\0", "config", "lualine.nvim")
time([[Config for lualine.nvim]], false)
-- Config for: hop.nvim
time([[Config for hop.nvim]], true)
try_loadstring("\27LJ\2\nU\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\tkeys\28etovxqpdygfblzhckisuran\nsetup\bhop\frequire\0", "config", "hop.nvim")
time([[Config for hop.nvim]], false)
-- Config for: nvim-autopairs
time([[Config for nvim-autopairs]], true)
try_loadstring("\27LJ\2\n@\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\19nvim-autopairs\frequire\0", "config", "nvim-autopairs")
time([[Config for nvim-autopairs]], false)
-- Config for: which-key.nvim
time([[Config for which-key.nvim]], true)
try_loadstring("\27LJ\2\n \6\0\0\6\0\26\0\0316\0\0\0'\2\1\0B\0\2\0029\1\2\0B\1\1\0019\1\3\0005\3\5\0005\4\4\0=\4\6\0035\4\a\0=\4\b\0035\4\t\0=\4\n\0035\4\v\0005\5\f\0=\5\r\4=\4\14\0035\4\15\0005\5\16\0=\5\r\0045\5\17\0=\5\18\4=\4\19\0035\4\21\0005\5\20\0=\5\22\0045\5\23\0=\5\24\4=\4\25\3B\1\2\1K\0\1\0\14<leader>b\16<leader>bcr\1\3\0\0\"<cmd>BufferLineCloseRight<cr>\31Close buffers to the right\6l\1\0\0\1\3\0\0!<cmd>BufferLineCloseLeft<cr>\30Close buffers to the left\14<leader>s\6F\1\3\0\0É\1<cmd>lua require'hop'.hint_char2({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = false })<cr>\22HOP before cursor\1\3\0\0Ç\1<cmd>lua require'hop'.hint_char2({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = false })<cr>\21HOP after cursor\1\0\1\tname\16Search/Jump\14<leader>f\6f\1\3\0\0\"<cmd>Telescope find_files<cr>\14Find File\1\0\1\tname\tFile\14<leader>q\1\3\0\0\15<cmd>q<cr>\16Quit buffer\14<leader>w\1\3\0\0\15<cmd>w<cr>\16Save buffer\n<C-n>\1\0\0\1\3\0\0\28<cmd>NvimTreeToggle<CR>\25Toggle file explorer\rregister\nsetup\14which-key\frequire\0", "config", "which-key.nvim")
time([[Config for which-key.nvim]], false)
-- Config for: Comment.nvim
time([[Config for Comment.nvim]], true)
try_loadstring("\27LJ\2\n5\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\fComment\frequire\0", "config", "Comment.nvim")
time([[Config for Comment.nvim]], false)
-- Config for: gitsigns.nvim
time([[Config for gitsigns.nvim]], true)
try_loadstring("\27LJ\2\n6\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\rgitsigns\frequire\0", "config", "gitsigns.nvim")
time([[Config for gitsigns.nvim]], false)
-- Config for: coq_nvim
time([[Config for coq_nvim]], true)
try_loadstring("\27LJ\2\nu\0\0\3\0\b\0\n6\0\0\0009\0\1\0005\1\3\0005\2\4\0=\2\5\1=\1\2\0006\0\6\0'\2\a\0B\0\2\1K\0\1\0\bcoq\frequire\vkeymap\1\0\1\17jump_to_mark\5\1\0\1\15auto_start\2\17coq_settings\6g\bvim\0", "config", "coq_nvim")
time([[Config for coq_nvim]], false)
-- Config for: nvim-tree.lua
time([[Config for nvim-tree.lua]], true)
try_loadstring("\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14nvim-tree\frequire\0", "config", "nvim-tree.lua")
time([[Config for nvim-tree.lua]], false)
-- Config for: alpha-nvim
time([[Config for alpha-nvim]], true)
try_loadstring("\27LJ\2\na\0\0\5\0\5\0\n6\0\0\0'\2\1\0B\0\2\0029\0\2\0006\2\0\0'\4\3\0B\2\2\0029\2\4\2B\0\2\1K\0\1\0\vconfig\27alpha.themes.dashboard\nsetup\nalpha\frequire\0", "config", "alpha-nvim")
time([[Config for alpha-nvim]], false)
-- Config for: mason.nvim
time([[Config for mason.nvim]], true)
try_loadstring("\27LJ\2\n3\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\nmason\frequire\0", "config", "mason.nvim")
time([[Config for mason.nvim]], false)
-- Config for: telescope.nvim
time([[Config for telescope.nvim]], true)
try_loadstring("\27LJ\2\n«\n\0\0\v\0M\0à\0016\0\0\0006\2\1\0'\3\2\0B\0\3\3\14\0\0\0X\2\1ÄK\0\1\0006\2\1\0'\4\3\0B\2\2\0029\3\4\0015\5D\0005\6\5\0005\a\6\0=\a\a\0065\a3\0005\b\t\0009\t\b\2=\t\n\b9\t\v\2=\t\f\b9\t\r\2=\t\14\b9\t\15\2=\t\16\b9\t\17\2=\t\18\b9\t\r\2=\t\19\b9\t\15\2=\t\20\b9\t\21\2=\t\22\b9\t\23\2=\t\24\b9\t\25\2=\t\26\b9\t\27\2=\t\28\b9\t\29\2=\t\30\b9\t\31\2=\t \b9\t!\2=\t\"\b9\t#\2=\t$\b9\t%\0029\n&\2 \t\n\t=\t'\b9\t%\0029\n(\2 \t\n\t=\t)\b9\t*\0029\n+\2 \t\n\t=\t,\b9\t-\0029\n+\2 \t\n\t=\t.\b9\t/\2=\t0\b9\t1\2=\t2\b=\b4\a5\b5\0009\t\17\2=\t6\b9\t\21\2=\t\22\b9\t\23\2=\t\24\b9\t\25\2=\t\26\b9\t\27\2=\t\28\b9\t%\0029\n&\2 \t\n\t=\t'\b9\t%\0029\n(\2 \t\n\t=\t)\b9\t*\0029\n+\2 \t\n\t=\t,\b9\t-\0029\n+\2 \t\n\t=\t.\b9\t\r\2=\t7\b9\t\15\2=\t8\b9\t9\2=\t:\b9\t;\2=\t<\b9\t=\2=\t>\b9\t\r\2=\t\19\b9\t\15\2=\t\20\b9\t9\2=\t?\b9\t=\2=\t@\b9\t\29\2=\t\30\b9\t\31\2=\t \b9\t!\2=\t\"\b9\t#\2=\t$\b9\t1\2=\tA\b=\bB\a=\aC\6=\6E\0054\6\0\0=\6F\0055\6J\0005\aH\0005\bG\0=\bI\a=\aK\6=\6L\5B\3\2\1K\0\1\0\15extensions\16media_files\1\0\0\14filetypes\1\0\1\rfind_cmd\arg\1\5\0\0\bpng\twebp\bjpg\tjpeg\fpickers\rdefaults\1\0\0\rmappings\6n\6?\6G\agg\6L\19move_to_bottom\6M\19move_to_middle\6H\16move_to_top\6k\6j\n<esc>\1\0\0\6i\1\0\0\n<C-_>\14which_key\n<C-l>\17complete_tag\n<M-q>\28send_selected_to_qflist\n<C-q>\16open_qflist\19send_to_qflist\f<S-Tab>\26move_selection_better\n<Tab>\25move_selection_worse\21toggle_selection\15<PageDown>\27results_scrolling_down\r<PageUp>\25results_scrolling_up\n<C-d>\27preview_scrolling_down\n<C-u>\25preview_scrolling_up\n<C-t>\15select_tab\n<C-v>\20select_vertical\n<C-x>\22select_horizontal\t<CR>\19select_default\t<Up>\v<Down>\n<C-c>\nclose\n<C-k>\28move_selection_previous\n<C-j>\24move_selection_next\n<C-p>\23cycle_history_prev\n<C-n>\1\0\0\23cycle_history_next\17path_display\1\2\0\0\nsmart\1\0\2\20selection_caret\tÔÅ§ \18prompt_prefix\tÔë´ \nsetup\22telescope.actions\14telescope\frequire\npcall\0", "config", "telescope.nvim")
time([[Config for telescope.nvim]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
try_loadstring("\27LJ\2\nã\2\0\0\6\0\r\0\0176\0\0\0'\2\1\0B\0\2\0029\1\2\0005\3\3\0005\4\4\0=\4\5\0035\4\6\0005\5\a\0=\5\b\4=\4\t\0035\4\n\0005\5\v\0=\5\b\4=\4\f\3B\1\2\1K\0\1\0\vindent\1\2\0\0\tyaml\1\0\1\venable\2\14highlight\fdisable\1\2\0\0\5\1\0\2\venable\2&additional_vim_regex_highlighting\2\19ignore_install\1\2\0\0\5\1\0\2\21ensure_installed\ball\17sync_install\1\nsetup\28nvim-treesitter.configs\frequire\0", "config", "nvim-treesitter")
time([[Config for nvim-treesitter]], false)
-- Config for: bufferline.nvim
time([[Config for bufferline.nvim]], true)
try_loadstring("\27LJ\2\n˝\1\0\0\6\0\b\0\r6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\6\0005\3\3\0004\4\3\0005\5\4\0>\5\1\4=\4\5\3=\3\a\2B\0\2\1K\0\1\0\foptions\1\0\0\foffsets\1\0\5\rfiletype\rNvimTree\ttext\14Directory\14highlight\14Directory\15text_align\vcenter\14separator\1\1\0\3\16diagnostics\rnvim_lsp\rtab_size\3\25!diagnostics_update_in_insert\1\nsetup\15bufferline\frequire\0", "config", "bufferline.nvim")
time([[Config for bufferline.nvim]], false)
-- Load plugins in order defined by `after`
time([[Sequenced loading]], true)
vim.cmd [[ packadd telescope-project.nvim ]]

-- Config for: telescope-project.nvim
try_loadstring("\27LJ\2\nL\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\fproject\19load_extension\14telescope\frequire\0", "config", "telescope-project.nvim")

vim.cmd [[ packadd telescope-media-files.nvim ]]

-- Config for: telescope-media-files.nvim
try_loadstring("\27LJ\2\nP\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\16media_files\19load_extension\14telescope\frequire\0", "config", "telescope-media-files.nvim")

vim.cmd [[ packadd mason-lspconfig.nvim ]]

-- Config for: mason-lspconfig.nvim
try_loadstring("\27LJ\2\n=\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\20mason-lspconfig\frequire\0", "config", "mason-lspconfig.nvim")

vim.cmd [[ packadd nvim-lspconfig ]]

-- Config for: nvim-lspconfig
try_loadstring("\27LJ\2\ng\0\1\3\0\3\0\a9\1\0\0+\2\1\0=\2\1\0019\1\0\0+\2\1\0=\2\2\1K\0\1\0\30document_range_formatting\24document_formatting\26resolved_capabilities \2\1\0\n\0\26\0\0316\0\0\0'\2\1\0B\0\2\0029\0\2\0009\0\3\0005\2\22\0005\3\20\0005\4\5\0005\5\4\0=\5\6\0045\5\b\0005\6\a\0=\6\t\5=\5\n\0045\5\15\0006\6\v\0009\6\f\0069\6\r\6'\b\14\0+\t\2\0B\6\3\2=\6\16\5=\5\17\0045\5\18\0=\5\19\4=\4\21\3=\3\23\0023\3\24\0=\3\25\2B\0\2\1K\0\1\0\14on_attach\0\rsettings\1\0\0\bLua\1\0\0\14telemetry\1\0\1\venable\1\14workspace\flibrary\1\0\0\5\26nvim_get_runtime_file\bapi\bvim\16diagnostics\fglobals\1\0\0\1\2\0\0\bvim\fruntime\1\0\0\1\0\1\fversion\vLuaJIT\nsetup\16sumneko_lua\14lspconfig\frequire\0", "config", "nvim-lspconfig")

time([[Sequenced loading]], false)
vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType rust ++once lua require("packer.load")({'rust-tools.nvim'}, { ft = "rust" }, _G.packer_plugins)]]
vim.cmd [[au FileType rs ++once lua require("packer.load")({'rust-tools.nvim'}, { ft = "rs" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
vim.cmd("augroup END")
if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end

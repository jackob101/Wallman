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
  ["coq.artifacts"] = {
    loaded = true,
    path = "/home/jakub/.local/share/nvim/site/pack/packer/start/coq.artifacts",
    url = "https://github.com/ms-jpq/coq.artifacts"
  },
  coq_nvim = {
    config = { "\27LJ\2\nU\0\0\3\0\6\0\b6\0\0\0009\0\1\0005\1\3\0=\1\2\0006\0\4\0'\2\5\0B\0\2\1K\0\1\0\bcoq\frequire\1\0\1\15auto_start\2\17coq_settings\6g\bvim\0" },
    loaded = true,
    path = "/home/jakub/.local/share/nvim/site/pack/packer/start/coq_nvim",
    url = "https://github.com/ms-jpq/coq_nvim"
  },
  ["nvim-autopairs"] = {
    config = { "\27LJ\2\n@\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\19nvim-autopairs\frequire\0" },
    loaded = true,
    path = "/home/jakub/.local/share/nvim/site/pack/packer/start/nvim-autopairs",
    url = "https://github.com/windwp/nvim-autopairs"
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
    config = { "\27LJ\2\né\1\0\0\5\0\a\0\v6\0\0\0'\2\1\0B\0\2\0029\1\2\0B\1\1\0019\1\3\0005\3\5\0005\4\4\0=\4\6\3B\1\2\1K\0\1\0\n<C-n>\1\0\0\1\3\0\0\28<cmd>NvimTreeToggle<CR>\25Toggle file explorer\rregister\nsetup\14which-key\frequire\0" },
    loaded = true,
    path = "/home/jakub/.local/share/nvim/site/pack/packer/start/which-key.nvim",
    url = "https://github.com/folke/which-key.nvim"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: nvim-tree.lua
time([[Config for nvim-tree.lua]], true)
try_loadstring("\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14nvim-tree\frequire\0", "config", "nvim-tree.lua")
time([[Config for nvim-tree.lua]], false)
-- Config for: nvim-autopairs
time([[Config for nvim-autopairs]], true)
try_loadstring("\27LJ\2\n@\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\19nvim-autopairs\frequire\0", "config", "nvim-autopairs")
time([[Config for nvim-autopairs]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
try_loadstring("\27LJ\2\nã\2\0\0\6\0\r\0\0176\0\0\0'\2\1\0B\0\2\0029\1\2\0005\3\3\0005\4\4\0=\4\5\0035\4\6\0005\5\a\0=\5\b\4=\4\t\0035\4\n\0005\5\v\0=\5\b\4=\4\f\3B\1\2\1K\0\1\0\vindent\1\2\0\0\tyaml\1\0\1\venable\2\14highlight\fdisable\1\2\0\0\5\1\0\2\venable\2&additional_vim_regex_highlighting\2\19ignore_install\1\2\0\0\5\1\0\2\21ensure_installed\ball\17sync_install\1\nsetup\28nvim-treesitter.configs\frequire\0", "config", "nvim-treesitter")
time([[Config for nvim-treesitter]], false)
-- Config for: coq_nvim
time([[Config for coq_nvim]], true)
try_loadstring("\27LJ\2\nU\0\0\3\0\6\0\b6\0\0\0009\0\1\0005\1\3\0=\1\2\0006\0\4\0'\2\5\0B\0\2\1K\0\1\0\bcoq\frequire\1\0\1\15auto_start\2\17coq_settings\6g\bvim\0", "config", "coq_nvim")
time([[Config for coq_nvim]], false)
-- Config for: which-key.nvim
time([[Config for which-key.nvim]], true)
try_loadstring("\27LJ\2\né\1\0\0\5\0\a\0\v6\0\0\0'\2\1\0B\0\2\0029\1\2\0B\1\1\0019\1\3\0005\3\5\0005\4\4\0=\4\6\3B\1\2\1K\0\1\0\n<C-n>\1\0\0\1\3\0\0\28<cmd>NvimTreeToggle<CR>\25Toggle file explorer\rregister\nsetup\14which-key\frequire\0", "config", "which-key.nvim")
time([[Config for which-key.nvim]], false)
-- Config for: telescope.nvim
time([[Config for telescope.nvim]], true)
try_loadstring("\27LJ\2\n«\n\0\0\v\0M\0à\0016\0\0\0006\2\1\0'\3\2\0B\0\3\3\14\0\0\0X\2\1ÄK\0\1\0006\2\1\0'\4\3\0B\2\2\0029\3\4\0015\5D\0005\6\5\0005\a\6\0=\a\a\0065\a3\0005\b\t\0009\t\b\2=\t\n\b9\t\v\2=\t\f\b9\t\r\2=\t\14\b9\t\15\2=\t\16\b9\t\17\2=\t\18\b9\t\r\2=\t\19\b9\t\15\2=\t\20\b9\t\21\2=\t\22\b9\t\23\2=\t\24\b9\t\25\2=\t\26\b9\t\27\2=\t\28\b9\t\29\2=\t\30\b9\t\31\2=\t \b9\t!\2=\t\"\b9\t#\2=\t$\b9\t%\0029\n&\2 \t\n\t=\t'\b9\t%\0029\n(\2 \t\n\t=\t)\b9\t*\0029\n+\2 \t\n\t=\t,\b9\t-\0029\n+\2 \t\n\t=\t.\b9\t/\2=\t0\b9\t1\2=\t2\b=\b4\a5\b5\0009\t\17\2=\t6\b9\t\21\2=\t\22\b9\t\23\2=\t\24\b9\t\25\2=\t\26\b9\t\27\2=\t\28\b9\t%\0029\n&\2 \t\n\t=\t'\b9\t%\0029\n(\2 \t\n\t=\t)\b9\t*\0029\n+\2 \t\n\t=\t,\b9\t-\0029\n+\2 \t\n\t=\t.\b9\t\r\2=\t7\b9\t\15\2=\t8\b9\t9\2=\t:\b9\t;\2=\t<\b9\t=\2=\t>\b9\t\r\2=\t\19\b9\t\15\2=\t\20\b9\t9\2=\t?\b9\t=\2=\t@\b9\t\29\2=\t\30\b9\t\31\2=\t \b9\t!\2=\t\"\b9\t#\2=\t$\b9\t1\2=\tA\b=\bB\a=\aC\6=\6E\0054\6\0\0=\6F\0055\6J\0005\aH\0005\bG\0=\bI\a=\aK\6=\6L\5B\3\2\1K\0\1\0\15extensions\16media_files\1\0\0\14filetypes\1\0\1\rfind_cmd\arg\1\5\0\0\bpng\twebp\bjpg\tjpeg\fpickers\rdefaults\1\0\0\rmappings\6n\6?\6G\agg\6L\19move_to_bottom\6M\19move_to_middle\6H\16move_to_top\6k\6j\n<esc>\1\0\0\6i\1\0\0\n<C-_>\14which_key\n<C-l>\17complete_tag\n<M-q>\28send_selected_to_qflist\n<C-q>\16open_qflist\19send_to_qflist\f<S-Tab>\26move_selection_better\n<Tab>\25move_selection_worse\21toggle_selection\15<PageDown>\27results_scrolling_down\r<PageUp>\25results_scrolling_up\n<C-d>\27preview_scrolling_down\n<C-u>\25preview_scrolling_up\n<C-t>\15select_tab\n<C-v>\20select_vertical\n<C-x>\22select_horizontal\t<CR>\19select_default\t<Up>\v<Down>\n<C-c>\nclose\n<C-k>\28move_selection_previous\n<C-j>\24move_selection_next\n<C-p>\23cycle_history_prev\n<C-n>\1\0\0\23cycle_history_next\17path_display\1\2\0\0\nsmart\1\0\2\20selection_caret\tÔÅ§ \18prompt_prefix\tÔë´ \nsetup\22telescope.actions\14telescope\frequire\npcall\0", "config", "telescope.nvim")
time([[Config for telescope.nvim]], false)
-- Load plugins in order defined by `after`
time([[Sequenced loading]], true)
vim.cmd [[ packadd telescope-media-files.nvim ]]

-- Config for: telescope-media-files.nvim
try_loadstring("\27LJ\2\nP\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\16media_files\19load_extension\14telescope\frequire\0", "config", "telescope-media-files.nvim")

vim.cmd [[ packadd telescope-project.nvim ]]

-- Config for: telescope-project.nvim
try_loadstring("\27LJ\2\nL\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\fproject\19load_extension\14telescope\frequire\0", "config", "telescope-project.nvim")

time([[Sequenced loading]], false)
if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end

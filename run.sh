#!/bin/bash

if [ "$EUID" -eq 0 ]
then
	echo "Script should not be run as root"
	exit
fi

dir="${HOME}/.config/nvim/pack/github/start"

git_clone() {

    direc=$dir/$(basename $1 | cut -d. -f1-2)

    if [ ! -d "$direc" ]
    then 
        git clone "$1" "$direc"
    fi
}

add_nvim_plugins() {
    mkdir -p $dir
    echo "downloading plugins..."

    git_clone https://github.com/turbio/bracey.vim.git
    git_clone https://github.com/neoclide/coc.nvim.git
    git_clone https://github.com/github/copilot.vim.git
    git_clone https://github.com/preservim/nerdtree.git
    git_clone https://gitlab.com/gabmus/vim-blueprint.git
    git_clone https://github.com/Pocco81/auto-save.nvim
    git_clone https://github.com/lewis6991/gitsigns.nvim
    git_clone https://github.com/Yggdroot/indentLine
    git_clone https://github.com/nvim-lualine/lualine.nvim
    git_clone https://github.com/tomasiser/vim-code-dark
    git_clone https://github.com/ryanoasis/vim-devicons
    git_clone https://github.com/voldikss/vim-floaterm
    git_clone https://github.com/tpope/vim-fugitive

    if ! dpkg -s npm >/dev/null 2>&1; then
        echo "Installing npm..."
        curl -sL install-node.vercel.app/lts | bash
    fi

    npm install --prefix $dir/bracey.vim/server
    npm install --prefix $dir/coc.nvim

    npm install coc-clangd
    npm install coc-tsserver
}

copy_file() {
	echo Copying $1 to $2
	cp -r "$1" "$2"
}

manual() {
	echo -e "\n\n"
	echo "Manual work required:"
	echo "Open any cpp fie and run :CocCommand clangd.install"
}

copy_file nvim "${HOME}/.config"
add_nvim_plugins

echo -e "\n\n"
echo "We require root permission to proceed with the following tasks..."
sudo ./run-root.sh

manual

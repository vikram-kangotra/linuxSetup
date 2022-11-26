#!/bin/bash

if [ "$EUID" -eq 0 ]
then
	echo "Script should not be run as root"
	exit
fi

add_nvim_plugins() {
    dir="${HOME}/.config/nvim/pack/github/start"
    mkdir -p $dir
    echo "downloading plugins..."
    git clone https://github.com/turbio/bracey.vim.git $dir/bracey.vim
    git clone https://github.com/neoclide/coc.nvim.git $dir/coc.nvim
    git clone https://github.com/github/copilot.vim.git $dir/copilot.vim
    git clone https://github.com/preservim/nerdtree.git $dir/nerdtree

    if ! dpkg -s npm >/dev/null 2>&1; then
        echo "Installing npm..."
        curl -sL install-node.vercel.app/lts | bash
    fi

    npm install --prefix $dir/coc.nvim

    npm install coc-clangd
}

copy_file() {
	echo Copying $1 to $2
	cp -r "$1" "$2"
}

manual() {
	echo -e "\n\n"
	echo "Manual workk required:"
	echo "Open any cpp fie and run :CocCommand clangd.install"
}

copy_file nvim "${HOME}/.config"
add_nvim_plugins

manual

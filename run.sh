#!/bin/bash

if [ "$EUID" -eq 0 ]
then
	echo "Script should not be run as root"
	exit
fi

git_clone() {
    direc="${HOME}/.config/nvim/pack/github/start"
    folder=$(echo $1 | rev | cut -d'/' -f1 | rev)
    folder=$(echo $folder | cut -d'.' -f1-2 )

    direc=$direc/$folder

    if [ ! -d "$direc" ]
    then 
        git clone "$1" "$direc"
    fi
}

add_nvim_plugins() {
    dir="${HOME}/.config/nvim/pack/github/start"
    mkdir -p $dir
    echo "downloading plugins..."

    git_clone https://github.com/turbio/bracey.vim.git
    git_clone https://github.com/neoclide/coc.nvim.git
    git_clone https://github.com/github/copilot.vim.git
    git_clone https://github.com/preservim/nerdtree.git


    if ! dpkg -s npm >/dev/null 2>&1; then
        echo "Installing npm..."
        curl -sL install-node.vercel.app/lts | bash
    fi

    npm install --prefix $dir/bracey.vim/server
    npm install --prefix $dir/coc.nvim

    echo $dir/coc.nvim

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

echo -e "\n\n"
echo "We require root permission to proceed with the following tasks..."
sudo ./run-root.sh

manual

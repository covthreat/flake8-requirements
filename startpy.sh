startpy() {
    if [ -n "\$2" ]; then
        if which python\$2 >/dev/null; then
            # Python version is installed
            :
        else
            echo "python\$2 isn't installed!" >&2
            return 1
        fi
    fi

    if [ -n "\$1" ]; then
        git clone https://github.com/hardcodd/flake8.git "\$1"
        cd "\$1" || return 1
        rm -rf .git

        if [ -n "\$2" ]; then
            virtualenv venv -p "\$2"
        else
            virtualenv venv
        fi

        source venv/bin/activate
        pip install --upgrade pip
        pip install -r flake8-requirements.txt
    else
        echo "Usage: startpy <folder_name> [optional <python version>]" >&2
        return 1
    fi
}
# Вызов функции с аргументами
startpy "$@"

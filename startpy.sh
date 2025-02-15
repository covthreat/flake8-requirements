startpy() {
  # Проверка наличия Python
  if [ -n "$2" ]; then
    if which python$2 >/dev/null; then
      :
    else
      echo "python$2 isn't installed!" >&2
      return 1
    fi
  fi

  # Проверка наличия имени папки
  if [ -n "$1" ]; then
    # Клонирование репозитория
    git clone https://github.com/covthreat/flake8-requirements.git $1 || {
      echo "Failed to clone repository!" >&2
      return 1
    }
    cd $1 || {
      echo "Failed to enter directory $1!" >&2
      return 1
    }

    # Удаление .git
    if [ -d ".git" ]; then
      rm -rf .git
    else
      echo "Failed to clone repository!" >&2
      return 1
    fi

    # Создание виртуального окружения
    if [ -n "$2" ]; then
      virtualenv venv -p python$2 || {
        echo "Failed to create virtual environment!" >&2
        return 1
      }
    else
      virtualenv venv || {
        echo "Failed to create virtual environment!" >&2
        return 1
      }
    fi

    # Активация виртуального окружения
    if [ -d "venv" ]; then
      source venv/bin/activate || {
        echo "Failed to activate virtual environment!" >&2
        return 1
      }
    else
      echo "Virtual environment not found!" >&2
      return 1
    fi

    # Обновление pip
    pip install --upgrade pip || {
      echo "Failed to upgrade pip!" >&2
      return 1
    }

    # Установка зависимостей
    if [ -f "flake8-requirements.txt" ]; then
      pip install -r flake8-requirements.txt || {
        echo "Failed to install dependencies!" >&2
        return 1
      }
    else
      echo "flake8-requirements.txt not found!" >&2
      return 1
    fi

  else
    echo "Usage: startpy <folder_name> [optional <python version>]" >&2
    return 1
  fi
}

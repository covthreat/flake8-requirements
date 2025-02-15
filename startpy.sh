#!/bin/bash

startpy() {
  # Проверка наличия аргументов
  if [ -z "$1" ]; then
    echo "Usage: startpy <folder_name> [optional <python version>]" >&2
    return 1
  fi

  echo "Starting project setup for folder: $1"

  # Проверка наличия Python
  if [ -n "$2" ]; then
    echo "Checking for Python $2..."
    if which python$2 >/dev/null; then
      echo "Python $2 found."
    else
      echo "python$2 isn't installed!" >&2
      return 1
    fi
  fi

  # Клонирование репозитория
  echo "Cloning repository..."
  git clone https://github.com/covthreat/flake8-requirements.git $1 || {
    echo "Failed to clone repository!" >&2
    return 1
  }
  echo "Repository cloned successfully."

  cd $1 || {
    echo "Failed to enter directory $1!" >&2
    return 1
  }

  # Удаление .git
  echo "Removing .git directory..."
  if [ -d ".git" ]; then
    rm -rf .git
    echo ".git directory removed."
  else
    echo "Failed to find .git directory!" >&2
    return 1
  fi

  # Создание виртуального окружения
  echo "Creating virtual environment..."
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
  echo "Virtual environment created."

  # Активация виртуального окружения
  echo "Activating virtual environment..."
  if [ -d "venv" ]; then
    source venv/bin/activate || {
      echo "Failed to activate virtual environment!" >&2
      return 1
    }
    echo "Virtual environment activated."
  else
    echo "Virtual environment not found!" >&2
    return 1
  fi

  # Обновление pip
  echo "Upgrading pip..."
  pip install --upgrade pip || {
    echo "Failed to upgrade pip!" >&2
    return 1
  }
  echo "pip upgraded."

  # Установка зависимостей
  echo "Installing dependencies..."
  if [ -f "flake8-requirements.txt" ]; then
    pip install -r flake8-requirements.txt || {
      echo "Failed to install dependencies!" >&2
      return 1
    }
    echo "Dependencies installed."
  else
    echo "flake8-requirements.txt not found!" >&2
    return 1
  fi

  echo "Project setup completed successfully!"
}

# Вызов функции с аргументами
startpy "$@"

<div align="center">

  <h1>🌌 Tokyo Night Sway</h1>

  <p><b>Эстетичная, быстрая и современная среда на базе Sway WM</b></p>

  <p>
    <img src="https://img.shields.io/badge/OS-Arch_Linux-blue?logo=arch-linux&logoColor=white&style=flat-square" alt="Arch Linux">
    <img src="https://img.shields.io/badge/WM-Sway-orange?style=flat-square" alt="Sway">
    <img src="https://img.shields.io/badge/Display_Server-Wayland-lightgrey?style=flat-square" alt="Wayland">
    <img src="https://img.shields.io/badge/Theme-Tokyo_Night-7aa2f7?style=flat-square" alt="Tokyo Night">
    <img src="https://img.shields.io/badge/License-MIT-green?style=flat-square" alt="MIT">
  </p>

  <p><i>Идеальный баланс между визуальным совершенством и бескомпромиссной скоростью.</i></p>

  ---
  
  [Особенности](#-особенности) • [Компоненты](#-компоненты) • [Установка](#-установка) • [Клавиши](#-горячие-клавиши)

</div>

## ✨ Особенности

- 🎨 **Цветовая палитра Tokyo Night**: Глубокие синие и неоновые акценты во всех элементах интерфейса.
- ⚡ **Максимальная легкость**: Использование компонентов, написанных на C и Rust, для мгновенного отклика.
- 🛠 **Умный инсталлятор**: Полностью автоматизированный скрипт развертывания с детекцией оборудования.
- 🧊 **Эффекты Wayland**: Плавные анимации, закругленные углы (swaylock) и безупречный тайлинг.
- 📦 **Готовность к работе**: Настроено всё — от управления яркостью до аппаратного ускорения видео.

## 🏗 Технический стек

| Роль | Инструмент | Описание |
| :--- | :--- | :--- |
| **Окружение** | [Sway](https://swaywm.org/) | i3-совместимый Wayland композитор |
| **Панель** | [Waybar](https://github.com/Alexays/Waybar) | Полностью кастомизированная статус-бар панель |
| **Терминал** | [Foot](https://codeberg.org/dnkl/foot) | Самый быстрый эмулятор терминала для Wayland |
| **Меню** | [Wofi](https://hg.sr.ht/~scoopta/wofi) | Легкий лаунчер приложений на GTK3 |
| **Уведомления** | [Mako](https://github.com/emersion/mako) | Лаконичный демон уведомлений |
| **Выход** | [Wlogout](https://github.com/ArtsyFarcy/wlogout) | Графическое меню завершения сеанса |

## ⌨️ Горячие клавиши

Основная клавиша (`Mod`) — **Super** (Windows Key).

*   `Mod + Enter` — Открыть терминал (**Foot**)
*   `Mod + D` — Запуск приложений (**Wofi**)
*   `Mod + B` — Браузер
*   `Mod + E` — Файловый менеджер (**Thunar**)
*   `Mod + Q` — Закрыть активное окно
*   `Mod + W` — Сменить обои (случайно)
*   `Mod + L` — Заблокировать экран
*   `Mod + 0` — Меню питания

## 🚀 Быстрый старт

### 1. Подготовка системы
Убедитесь, что у вас установлен свежий **Arch Linux**.

### 2. Установка
Просто склонируйте этот репозиторий и запустите скрипт. Скрипт сам определит ваше железо, установит драйверы, шрифты и разложит конфигурационные файлы.

```bash
git clone https://github.com/ВАШ_НИК/dotfiles-sway.git
cd dotfiles-sway
chmod +x install.sh
./install.sh
```
### 3. Первый запуск
После завершения установки перезагрузите систему и в консоли введите:

```bash
sway
```

### 📂 Структура проекта

```
.
├── install.sh              # Интеллектуальный скрипт установки
├── configs/                # Директория конфигурационных файлов
│   ├── sway/               # Логика оконного менеджера
│   ├── waybar/             # Стили панели
│   ├── foot/               # Настройки терминала
│   └── ...                 # Прочие конфиги (wofi, mako, wlogout)
├── scripts/                # Скрипты для смены обоев и блокировки
└── assets/                 # Обои и визуальные ресурсы
```

<div align="center">
P.S. I use Arch BTW...
</div>
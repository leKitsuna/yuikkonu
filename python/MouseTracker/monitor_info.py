import screeninfo

def get_monitors_info():
    try:
        monitors = screeninfo.get_monitors()
        monitors_info = []
        for monitor in monitors:
            monitor_info = {
                "name": monitor.name,
                "x": monitor.x,
                "y": monitor.y,
                "width": monitor.width,
                "height": monitor.height,
                "width_mm": monitor.width_mm,
                "height_mm": monitor.height_mm,
                "is_primary": monitor.is_primary
            }
            monitors_info.append(monitor_info)
        return monitors_info
    except Exception as e:
        print(f"Ошибка при получении информации о мониторах: {e}")
        return []

if __name__ == '__main__':
    monitors = get_monitors_info()
    if monitors:
        for i, monitor in enumerate(monitors):
            print(f"--- Монитор #{i+1} ---")
            for key, value in monitor.items():
                print(f"{key}: {value}")
            print()
    else:
        print("Не удалось получить информацию о мониторах.")
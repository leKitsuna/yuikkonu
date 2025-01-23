import pyautogui
import time

def get_mouse_position():
    try:
        x, y = pyautogui.position()
        return (x, y)
    except Exception as e:
        print(f"Ошибка при получении позиции курсора: {e}")
        return None

if __name__ == '__main__':
    try:
        while True:
            position = get_mouse_position()
            if position:
                print(f"Позиция курсора: x={position[0]}, y={position[1]}", end='\r')  # Вывод с перезаписью
            time.sleep(0.1)  # Задержка, чтобы не заспамить консоль
    except KeyboardInterrupt:
        print("\nПрограмма завершена.")
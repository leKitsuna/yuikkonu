from PySide6 import QtCore, QtWidgets
import sys, screeninfo, pyautogui

startstr = ["Not ready yet...", "Press start", "Press the button below", "Need a monitor info"]

class MyWidget(QtWidgets.QWidget):
    def __init__(self):
        super().__init__()
        self.MainWindowSettings()
        self.Appearence()
    
    def MainWindowSettings(self) -> None:
        self.setFixedSize(320, 240)
        self.setWindowTitle("MouseTracker")
        self.layout = QtWidgets.QGridLayout(self)
        self.timer = QtCore.QTimer(self)
        self.timer.timeout.connect(self.update_info)
        self.timer.start(200)
        
    def Appearence(self):
        self.CursorLabel = QtWidgets.QLabel("", alignment=QtCore.Qt.AlignCenter)
        self.layout.addWidget(self.CursorLabel)
        
    def get_monitor_info(self):
        try:
            x, y = pyautogui.position()
            monitors = screeninfo.get_monitors()
            for monitor in monitors:
                if monitor.x <= x < monitor.x + monitor.width and monitor.y <= y < monitor.y + monitor.height:
                    return monitor, (monitor.width, monitor.height), (x,y)
            return None, None, None
        except Exception:
            return None, None, None
    
    def update_info(self):
        monitor, resolution, position = self.get_monitor_info()
        if monitor and resolution and position:
            self.CursorLabel.setText(f"Монитор: {monitor.name}\nРазрешение: {resolution[0]}x{resolution[1]}\nПозиция курсора: x={position[0]}, y={position[1]}")
        else:
            self.CursorLabel.setText("Курсор не на экране\nПозиция курсора: ")
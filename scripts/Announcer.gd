extends CanvasLayer

func _ready():
    Globals.announcer = self

func announce(text, time=3.0):
    $DialogBox/DialogText.text = text
    $DialogBox.visible = true
    
    $Notification.play()

    yield(get_tree().create_timer(time), "timeout")
    
    $DialogBox.visible = false


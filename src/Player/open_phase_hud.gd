extends CanvasLayer

@onready var DesignMenu = $DesignMenu
@onready var TimeLeft = $Time

var timer: Timer

func _process(_delta):
	if is_instance_valid(timer):
		TimeLeft.text = getTimerText()

func getTimerText():
	var timerText
	
	var secs = fmod(timer.time_left, 60)
	var mins = fmod(timer.time_left, 60*60) / 60
	
	timerText = "%02d : %02d" % [mins,secs]
	
	if timerText == "00 : 00":
		timerText = "Once Visitors Leave, Progress to Next Day"
	return timerText


func _on_brush_pressed():
	Globals.selected_action = Callable(Actions, "brush")
	Globals.cursor.setCursorAsBrush()


func _on_feed_pressed():
	Globals.selected_action = Callable(Actions, "feed")
	Globals.cursor.setCursorAsFeed()


func _on_collect_pressed():
	Globals.selected_action = Callable(Actions, "collect")
	Globals.cursor.setStaticCursor("hand")
	

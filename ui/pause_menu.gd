extends Control

@onready var resume_button: Button = $Panel/VBoxContainer/ResumeButton
@onready var quit_button: Button = $Panel/VBoxContainer/QuitButton
@onready var sensitivity_slider: HSlider = $Panel/VBoxContainer/SensitivityRow/HSlider
@onready var sensitivity_value: Label = $Panel/VBoxContainer/SensitivityRow/Value
@onready var invert_y_toggle: CheckButton = $Panel/VBoxContainer/InvertRow/CheckButton
@onready var fov_slider: HSlider = $Panel/VBoxContainer/FOVRow/HSlider
@onready var fov_value: Label = $Panel/VBoxContainer/FOVRow/Value
@onready var headbob_toggle: CheckButton = $Panel/VBoxContainer/HeadBobRow/CheckButton
@onready var volume_slider: HSlider = $Panel/VBoxContainer/VolumeRow/HSlider
@onready var volume_value: Label = $Panel/VBoxContainer/VolumeRow/Value

func _ready() -> void:
    visible = false
    process_mode = Node.PROCESS_MODE_ALWAYS
    
    resume_button.pressed.connect(_on_resume_pressed)
    quit_button.pressed.connect(_on_quit_pressed)
    sensitivity_slider.value_changed.connect(_on_sensitivity_changed)
    invert_y_toggle.toggled.connect(_on_invert_toggled)
    fov_slider.value_changed.connect(_on_fov_changed)
    headbob_toggle.toggled.connect(_on_headbob_toggled)
    volume_slider.value_changed.connect(_on_volume_changed)
    
    _update_values_from_state()
    GameState.pause_changed.connect(_on_pause_state_changed)
    GameState.mouse_sensitivity_changed.connect(_on_mouse_sensitivity_sync)
    GameState.fov_changed.connect(_on_fov_sync)
    GameState.head_bob_changed.connect(_on_headbob_sync)
    GameState.master_volume_changed.connect(_on_volume_sync)
    GameState.invert_y_changed.connect(_on_invert_sync)

func _update_values_from_state() -> void:
    sensitivity_slider.value = GameState.mouse_sensitivity
    sensitivity_value.text = "%.2f" % GameState.mouse_sensitivity
    invert_y_toggle.button_pressed = GameState.invert_y
    fov_slider.value = GameState.base_fov
    fov_value.text = "%d" % int(GameState.base_fov)
    headbob_toggle.button_pressed = GameState.head_bob_enabled
    volume_slider.value = GameState.master_volume
    volume_value.text = "%d%%" % int(GameState.master_volume * 100)

func _on_resume_pressed() -> void:
    GameState.set_pause_state(false)

func _on_quit_pressed() -> void:
    GameState.request_quit()

func _on_sensitivity_changed(value: float) -> void:
    GameState.set_mouse_sensitivity(value)
    sensitivity_value.text = "%.2f" % GameState.mouse_sensitivity

func _on_invert_toggled(pressed: bool) -> void:
    GameState.set_invert_y(pressed)

func _on_fov_changed(value: float) -> void:
    GameState.set_base_fov(value)
    fov_value.text = "%d" % int(GameState.base_fov)

func _on_headbob_toggled(pressed: bool) -> void:
    GameState.set_head_bob_enabled(pressed)

func _on_volume_changed(value: float) -> void:
    GameState.set_master_volume(value)
    volume_value.text = "%d%%" % int(GameState.master_volume * 100)

func _on_pause_state_changed(is_paused: bool) -> void:
    visible = is_paused
    if visible:
        resume_button.grab_focus()

func _on_mouse_sensitivity_sync(value: float) -> void:
    sensitivity_slider.value = value
    sensitivity_value.text = "%.2f" % value

func _on_fov_sync(value: float) -> void:
    fov_slider.value = value
    fov_value.text = "%d" % int(value)

func _on_headbob_sync(enabled: bool) -> void:
    headbob_toggle.button_pressed = enabled

func _on_volume_sync(value: float) -> void:
    volume_slider.value = value
    volume_value.text = "%d%%" % int(value * 100)

func _on_invert_sync(enabled: bool) -> void:
    invert_y_toggle.button_pressed = enabled

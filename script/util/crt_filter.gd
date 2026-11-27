extends CanvasLayer

@export var CameraContainer: Node2D
const CHANGE_TIME = 4

func _process(delta: float) -> void:
	change(delta)
	shake(delta)

func shake(delta) -> void:
	if CameraContainer and Global.crt:
			for cam in CameraContainer.get_children():
				if cam is Camera2D and cam.has_method("screen_shake"):
					if Global.strongerCrt:
						cam.screen_shake(30, delta)
					else:
						cam.screen_shake(5, delta)

func change(_delta) -> void:
	if Global.toCrt and $ColorRect.material.get_shader_parameter("vignette_intensity") == 0.4:
		Global.toCrt = false
		get_tree().create_tween().tween_method(
			func(val: float): $ColorRect.material.set_shader_parameter("aberration_amount", val),
			0.003,
			0.033,
			CHANGE_TIME
		)
		get_tree().create_tween().tween_method(
			func(val: float): $ColorRect.material.set_shader_parameter("line_count", val),
			240.0,
			300.0,
			CHANGE_TIME
		)
		get_tree().create_tween().tween_method(
			func(val: float): $ColorRect.material.set_shader_parameter("scanline_opacity", val),
			0.2,
			0.785,
			CHANGE_TIME
		)
		get_tree().create_tween().tween_method(
			func(val: float): $ColorRect.material.set_shader_parameter("vignette_intensity", val),
			0.4,
			2.89,
			CHANGE_TIME
		)
		await get_tree().create_timer(CHANGE_TIME).timeout
		Global.crt = true
	elif Global.crt:
		$ColorRect.material.set_shader_parameter("aberration_amount", 0.05)
		$ColorRect.material.set_shader_parameter("line_count", 300.0)
		$ColorRect.material.set_shader_parameter("scanline_opacity", 1.0)
		$ColorRect.material.set_shader_parameter("vignette_intensity", 2.89)
	else:
		$ColorRect.material.set_shader_parameter("aberration_amount", 0.003)
		$ColorRect.material.set_shader_parameter("line_count", 240.0)
		$ColorRect.material.set_shader_parameter("scanline_opacity", 0.2)
		$ColorRect.material.set_shader_parameter("vignette_intensity", 0.4)

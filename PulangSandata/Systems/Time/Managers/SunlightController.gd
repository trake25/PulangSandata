# SunlightController.gd
extends DirectionalLight2D  # or CanvasLayer if using shader method

const PHASE_LIGHT := {
	"Midnight": {
		"energy": 0.05,  # Very dim
		"color": Color(0.2, 0.2, 0.3)  # Cool, muted blue-gray
	},
	"Morning": {
		"energy": 0.2,  # Soft morning light
		"color": Color(1.0, 0.85, 0.6)  # Warm yellow-orange
	},
	"Afternoon": {
		"energy": 0.4,  # Brightest
		"color": Color(1.0, 1.0, 0.9)  # Neutral white with daylight tint
	},
	"Evening": {
		"energy": 0.1,  # Starting to dim
		"color": Color(1.0, 0.6, 0.4)  # Sunset orange-pink
	},
}


func _ready() -> void:
	Initializer.sunlight_controller = self
	Initializer.sunlightcontroller_isready = true
	print("SunlightController is ready.")

func _get_sun_angle(hour: int) -> float:
	# Map 24h to 360° sun cycle: 0h → -90°, 6h → 0°, 12h → 90°, 18h → 180°, 24h → 270°
	return lerp(0.0, 360.0, float(hour % 24) / 24.0)


func update_sunlight(time_state: Time_State):
	var hour = time_state.hour
	var phase = time_state.get_phase()

	# Interpolate angle between known hour anchors
	rotation_degrees = _get_sun_angle(hour)

	# Adjust energy and color
	if PHASE_LIGHT.has(phase):
		var config = PHASE_LIGHT[phase]
		energy = config["energy"]
		color = config["color"]

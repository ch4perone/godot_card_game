extends Card

func apply_effects(targets: Array[Node]):
	var changed_temperature_effect := ChangeTemperatureEffect.new()
	
	changed_temperature_effect.value = -2.0
	changed_temperature_effect.execute(targets)


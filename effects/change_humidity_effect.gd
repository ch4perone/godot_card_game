class_name ChangeHumidityEffect
extends Effect

var value := 0.0

func execute(targets: Array[Node]) -> void:
	
	for target in targets:
		if not target:
			continue
		if target is Player:
			target.change_humidity(value)

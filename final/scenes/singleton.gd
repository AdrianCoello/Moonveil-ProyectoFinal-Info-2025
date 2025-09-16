extends Node

var power_up_1: bool = true  # wall-jump/climb activo
var power_up_2: bool = true  # escalado de tamaño activo

func set_power_up_1(v: bool) -> void:
	power_up_1 = v

func set_power_up_2(v: bool) -> void:
	power_up_2 = v

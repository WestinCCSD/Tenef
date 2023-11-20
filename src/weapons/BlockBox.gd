class_name BlockBox
extends Area2D


signal shield_struck(area)


export(float) var blocking_power = 0.0 # % from 0.0 - 1.0
export(float) var parry_power = 1.5 # % increase from blocking power (default is 1.5 or 150%)



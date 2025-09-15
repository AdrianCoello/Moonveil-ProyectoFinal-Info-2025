class_name StateBase extends Node
## Reutilizamos para cualquier tipo de nodo
@onready var controlled_node:Node = self.owner

## Maquina de estado
var state_machine:StateMachine

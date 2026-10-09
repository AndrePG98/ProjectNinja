class_name States extends RefCounted

enum State { IDLE, RUNNING, JUMPING, FALLING, HOOKING, FAINT }

const GROUNDED_STATES: Array[State] = [State.IDLE, State.RUNNING]
const AIRBORNE_STATES: Array[State] = [State.JUMPING, State.FALLING]

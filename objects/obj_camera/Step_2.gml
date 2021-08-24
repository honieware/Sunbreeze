/// @description Follow the player character

if (instance_exists(target)) {
	//viewx	= target.x;
	//viewy	= target.y;
	if (global.lockXCamera) { viewx = 320 / 2; }
	else { viewx	= lerp(viewx, target.x, 0.15); }
	if (global.lockYCamera) { viewy = 180 / 2; }
	else { viewy	= lerp(viewy, target.y, 0.15); }
	
	vm		= matrix_build_lookat(viewx, viewy, -10, viewx, viewy, 0, 0, 1, 0);
	camera_set_view_mat(camera, vm);
}
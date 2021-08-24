camera	= camera_create();
vm		= matrix_build_lookat(0, 0, -10, 0, 0, 0, 0, 1, 0);// View matrix.
// globalWidth and globalHeight don't work right now, don't ask me why
pm		= matrix_build_projection_ortho(320, 180, 1, 3200);

viewx	= 0;
viewy	= 0;
target	= obj_player;

// (si hacés clic)
if position_meeting(mouse_x, mouse_y, self) && mouse_check_button_pressed(mb_left) {
	if (timesClicked == 0) {
		create_textbox("rover_welcome");
		timesClicked++;
	} else {
		create_textbox("rover_repeat");
	}
}
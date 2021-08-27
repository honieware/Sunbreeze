// @param text_id
function scr_game_script(_text_id){
	switch (_text_id) {
		
		case "rover_welcome":
			scr_text("Hello! The name's Rover. How about you, mrrow?");
			scr_text("...What, cat got your tongue?");
			scr_text("Suit yourself, par'ner. Mutes have it easy, you know.");
			scr_text("Don't have to say a single thing and people will still talk to you.");
			break;
			
		case "rover_repeat":
			scr_text("Dude, I'm just a game NPC.");
			scr_text("I'll be repeating this dialogue until you move on.");
			break;
			
		case "adam_levine":
			scr_text("Well, looky here, looky here, ah, what do we have?");
			scr_text("Another pretty thang ready for me to grab");
			scr_text("But little does she know, that I'm a wolf in sheep's clothing");
			scr_text("'Cause at the end of the night it is her I'll be holding");
			break;
			
		case "questions":
			scr_text("Why is it dark when I go outside?")
				scr_option("And why can't I look at the sun?", "questions - sun");
				scr_option("Because the light goes away", "questions - lyrics");
			break;
			case "questions - sun":
				scr_text("And how come when I look at the sun it hurts my eyes and it makes me blind?")
				break;
			case "questions - lyrics":
				scr_text("Come on, man, that's not how the song goes!");
				break;
	}
}
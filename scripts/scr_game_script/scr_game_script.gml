// @param text_id
function scr_game_script(_text_id){
	switch (_text_id) {
		
		// Example dialogue!
		case "rover_welcome":
			scr_text("Hello! The name's Rover. How about you, mrrow?", "Rover");
			scr_text("Hello! The name'sasdaow?", "Rover");
			scr_option("Just a journalist.", "journal");
			scr_option("Don't have one.", "no_name");
			scr_option("...", "tongue");
			break;
			case "journal":
				scr_text("Aaaah. So I take it you're one of those low-lifes, then?");
				scr_text("...Pffft, I was just kidding! You should've seen the look in your mug -");
				scr_text("You're good, you're good.");
				break;
			case "no_name":
				scr_text("Whaaaat?!");
				scr_text("What do you mean you have no name? EVERYONE'S got a name!");
				scr_option("Well, I don't.", "push_through");
				scr_option("Consider yourself lucky.", "tease");
				break;
				case "push_through":
					scr_text("My, my! I'm glad to hear there's still plenty of rude people in the world.");
					scr_text("Y'know what? I'm gonna sit here, just to spite you.");
					scr_text("Make this plane ride less plain and all.");
					break;
				case "tease":
					scr_text("I suppose I should, shouldn't I?");
					scr_text("At least I'm not some 'Unknown Cat' of sorts...");
					break;
			case "tongue":
				scr_text("...What, cat got your tongue?");
				scr_text("Suit yourself, par'ner. Mutes have it easy, you know.");
				scr_text("Don't have to say a single thing and people will still talk to you.");
				break;
			
		case "rover_repeat":
			scr_text("Dude, I'm just a game NPC.");
			scr_text("I'll be repeating this dialogue until you move on.");
			scr_text("It'd be smart to...");
			break;
	}
}
package main

import rl "vendor:raylib"

WINDOW_WIDTH :: 2000
WINDOW_HEIGHT :: 600
CARD_WIDTH :: 120.0
CARD_HEIGHT :: 180.0
CARD_ANGLE_MAG :: 10.0
FPS :: 60
MAX_CARD_COUNT :: 7
ARC_HEIGHT :: 25

COLORS: [MAX_CARD_COUNT]rl.Color = {
	rl.RED,
	rl.BLUE,
	rl.YELLOW,
	rl.GREEN,
	rl.PURPLE,
	rl.ORANGE,
	rl.BROWN,
}

Card :: struct {
	rect:     rl.Rectangle,
	rotation: f32,
	color:    rl.Color,
}

init_cards :: proc(cards: ^[dynamic]Card, cards_len: int) {
	if cards_len <= 0 {
		return
	}

	if cards_len == 1 {
		cards^[0].rect.x = WINDOW_WIDTH / 2
		cards^[0].rect.y = WINDOW_HEIGHT - 50
		cards^[0].rect.width = CARD_WIDTH
		cards^[0].rect.height = CARD_HEIGHT
		cards^[0].rotation = 0
		cards^[0].color = COLORS[0]
		return
	}

	offset_x: f32 = (WINDOW_WIDTH - (CARD_WIDTH * cast(f32)cards_len)) / 2
	base_y: f32 = WINDOW_HEIGHT - 50
	rotation_incr: f32 = -CARD_ANGLE_MAG
	for i := 0; i < cards_len; i = i + 1 {
		cards^[i].rect.x = offset_x + (CARD_WIDTH / 2)
		t := (f32(i) - f32(cards_len - 1) / 2) / (f32(cards_len - 1) / 2)
		offset_y_arc := -ARC_HEIGHT * (1 - t * t)
		cards^[i].rect.y = base_y + offset_y_arc
		cards^[i].rect.width = CARD_WIDTH
		cards^[i].rect.height = CARD_HEIGHT
		cards^[i].rotation = rotation_incr
		cards^[i].color = COLORS[i]

		offset_x += CARD_WIDTH - 20

		rotation_incr += (CARD_ANGLE_MAG * 2) / (cast(f32)cards_len - 1)
	}
}

main :: proc() {

	rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "Card game")

	origin := rl.Vector2{CARD_WIDTH / 2, CARD_HEIGHT}

	rl.SetTargetFPS(FPS)
	delta_cards := 0
	seconds_timer: f32 = 0
	cards: [dynamic]Card

	for !rl.WindowShouldClose() {

		seconds_timer += rl.GetFrameTime()

		if seconds_timer >= 1.0 {
			seconds_timer -= 1.0
			delta_cards += 1
			if delta_cards > MAX_CARD_COUNT {
				delta_cards = 0
			}
		}


		resize_dynamic_array(&cards, delta_cards)
		init_cards(&cards, delta_cards)

		rl.BeginDrawing()
		rl.ClearBackground(rl.BLACK)

		for card in cards {
			rl.DrawRectanglePro(card.rect, origin, card.rotation, card.color)
		}

		rl.EndDrawing()
	}

	delete(cards)

	rl.CloseWindow()
}

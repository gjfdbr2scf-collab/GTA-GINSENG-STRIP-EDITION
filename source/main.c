#include <nds.h>
#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include "game.h"

static ScreenState screen = SCREEN_LANGUAGE;
static CameraMode cameraMode = CAMERA_THIRD_PERSON;
static LowerMode lowerMode = LOWER_MAP;
static Player player = { 128, 96, 0, 500, 0, 0, false, false, false };

static int menuIndex = 0;
static char username[13] = "PLAYER";
static const char *languages[] = {"Deutsch", "English"};
static const char *skins[] = {"Street", "Urban", "Agent"};

static PointOfInterest pois[] = {
    { 180,  80, "MILITARY", false },
    {  70,  50, "AIRPORT", false },
    { 220, 150, "SHOP", false },
    { 100, 160, "MISSION", false }
};

static void clear_console(void) {
    consoleClear();
}

static void draw_header(const char *title) {
    iprintf("\x1b[1;1H%s\n", title);
    iprintf("--------------------------------\n");
}

static void draw_controls(void) {
    iprintf("\n\nCONTROLS\n");
    iprintf("D-PAD  Move\n");
    iprintf("A      Interact / Enter\n");
    iprintf("B      Back\n");
    iprintf("SELECT Camera\n");
    iprintf("START  Vehicle / Exit\n");
    iprintf("X      Phone\n");
    iprintf("Y      SECRET (special car)\n");
    iprintf("L/R    Aim / aircraft control\n");
}

static void language_screen(void) {
    clear_console();
    draw_header("GINSENG STRIP GTA");
    iprintf("LANGUAGE / SPRACHE\n\n");
    for (int i = 0; i < 2; ++i)
        iprintf("%s %s\n", i == menuIndex ? ">" : " ", languages[i]);
    iprintf("\nA = SELECT");
}

static void username_screen(void) {
    clear_console();
    draw_header("USERNAME");
    iprintf("Name: %s_\n\n", username);
    iprintf("A: next letter   B: previous\n");
    iprintf("START: finish");
    iprintf("\nUse D-PAD to choose a letter.");
}

static void skin_screen(void) {
    clear_console();
    draw_header("CHOOSE YOUR SKIN");
    for (int i = 0; i < 3; ++i)
        iprintf("%s %s\n", i == menuIndex ? ">" : " ", skins[i]);
    iprintf("\nA = choose");
}

static void world_screen(void) {
    clear_console();
    draw_header("GINSENG STRIP GTA");

    iprintf("CAM: %s\n",
        cameraMode == CAMERA_THIRD_PERSON ? "THIRD PERSON" : "FIRST PERSON");
    iprintf("PLAYER: %s\n", username);
    iprintf("MONEY: $%d\n", player.money);
    iprintf("POS: %d,%d\n", player.x, player.y);

    iprintf("\nLOWER SCREEN: ");
    if (lowerMode == LOWER_MAP) iprintf("MAP");
    else if (lowerMode == LOWER_PHONE) iprintf("PHONE");
    else iprintf("MUSIC");

    iprintf("\n\nSPECIAL LOCATIONS\n");
    for (unsigned i = 0; i < sizeof(pois)/sizeof(pois[0]); ++i)
        iprintf("%s %s\n", pois[i].discovered ? "*" : " ", pois[i].name);

    iprintf("\n");
    draw_controls();
}

static void lower_map(void) {
    consoleClear();
    iprintf("======== MAP ========\n");
    iprintf("        N\n");
    iprintf("        ^\n");
    iprintf("   AIRPORT     SHOP\n");
    iprintf("       \\       /\n");
    iprintf("        +-----+\n");
    iprintf("        |  P  |\n");
    iprintf("        +-----+\n");
    iprintf("     MILITARY   MISSION\n");
    iprintf("\nP = PLAYER\n");
    iprintf("\nPhone [X]  Music [Y]\n");
    iprintf("Radio appears in vehicle.\n");
}

static void lower_phone(void) {
    consoleClear();
    iprintf("======== PHONE ========\n");
    iprintf("CONTACTS\n");
    iprintf("> Dispatch\n");
    iprintf("  Friend\n");
    iprintf("  Airport\n");
    iprintf("  Military\n");
    iprintf("\nA = call\nB = map");
}

static void lower_music(void) {
    consoleClear();
    iprintf("======== MUSIC ========\n");
    iprintf("TRACK PLAYER\n\n");
    iprintf("> Street Drive\n");
    iprintf("  Night Run\n");
    iprintf("  Mission\n");
    iprintf("\nA = play/stop\nB = map");
    if (player.inVehicle)
        iprintf("\nRADIO: AVAILABLE");
}

static void lower_screen(void) {
    switch (lowerMode) {
        case LOWER_PHONE: lower_phone(); break;
        case LOWER_MUSIC: lower_music(); break;
        default: lower_map(); break;
    }
}

static void move_player(u16 keys) {
    if (keys & KEY_UP)    player.y -= 2;
    if (keys & KEY_DOWN)  player.y += 2;
    if (keys & KEY_LEFT)  player.x -= 2;
    if (keys & KEY_RIGHT) player.x += 2;

    if (player.x < 10) player.x = 10;
    if (player.x > 240) player.x = 240;
    if (player.y < 10) player.y = 10;
    if (player.y > 180) player.y = 180;
}

static void discover_places(void) {
    for (unsigned i = 0; i < sizeof(pois)/sizeof(pois[0]); ++i) {
        int dx = player.x - pois[i].x;
        int dy = player.y - pois[i].y;
        if (dx*dx + dy*dy < 18*18)
            pois[i].discovered = true;
    }
}

void game_init(void) {
    consoleDemoInit();
    /* Stable 2D startup: this prototype does not require the 3D engine. */
    videoSetMode(MODE_0_2D);
    videoSetModeSub(MODE_0_2D);
    consoleSetWindow(NULL, 0, 0, 32, 24);
}

void game_update(void) {
    scanKeys();
    u16 down = keysDown();
    u16 held = keysHeld();

    if (screen == SCREEN_LANGUAGE) {
        if (down & KEY_UP) menuIndex = 0;
        if (down & KEY_DOWN) menuIndex = 1;
        if (down & KEY_A) { menuIndex = 0; screen = SCREEN_USERNAME; }
        return;
    }

    if (screen == SCREEN_USERNAME) {
        if (down & KEY_START) screen = SCREEN_SKIN;
        return;
    }

    if (screen == SCREEN_SKIN) {
        if (down & KEY_UP) menuIndex = (menuIndex + 2) % 3;
        if (down & KEY_DOWN) menuIndex = (menuIndex + 1) % 3;
        if (down & KEY_A) {
            player.skin = menuIndex;
            screen = SCREEN_WORLD;
        }
        return;
    }

    move_player(held);

    if (down & KEY_SELECT)
        cameraMode = cameraMode == CAMERA_THIRD_PERSON ?
                     CAMERA_FIRST_PERSON : CAMERA_THIRD_PERSON;

    if (down & KEY_X) lowerMode = LOWER_PHONE;
    if (down & KEY_Y) lowerMode = LOWER_MUSIC;
    if (down & KEY_B) lowerMode = LOWER_MAP;

    if (down & KEY_START)
        player.inVehicle = !player.inVehicle;

    /* SECRET is deliberately gated to the special vehicle. */
    if ((down & KEY_Y) && player.specialVehicle) {
        /* Turret state would be toggled here. */
    }

    discover_places();
}

void game_draw(void) {
    if (screen == SCREEN_LANGUAGE) language_screen();
    else if (screen == SCREEN_USERNAME) username_screen();
    else if (screen == SCREEN_SKIN) skin_screen();
    else world_screen();

    lower_screen();
}

int main(void) {
    game_init();

    while (1) {
        game_update();
        game_draw();
        swiWaitForVBlank();
    }

    return 0;
}

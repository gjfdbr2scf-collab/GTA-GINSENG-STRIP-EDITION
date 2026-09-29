#ifndef GAME_H
#define GAME_H

#include <nds.h>
#include <stdbool.h>

typedef enum {
    SCREEN_LANGUAGE,
    SCREEN_USERNAME,
    SCREEN_SKIN,
    SCREEN_WORLD
} ScreenState;

typedef enum {
    CAMERA_THIRD_PERSON,
    CAMERA_FIRST_PERSON
} CameraMode;

typedef enum {
    LOWER_MAP,
    LOWER_PHONE,
    LOWER_MUSIC
} LowerMode;

typedef struct {
    int x, y, z;
    int money;
    int skin;
    int vehicle;
    bool inVehicle;
    bool inPlane;
    bool specialVehicle;
} Player;

typedef struct {
    int x, y;
    const char *name;
    bool discovered;
} PointOfInterest;

void game_init(void);
void game_update(void);
void game_draw(void);

#endif

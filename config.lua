
Config = {}

Config.Menu = {
    help = 'Lightbar Menü öffnen',
    command = 'lightbar',
    jobs = {'police', 'sheriff', 'fib'},
}

Config.Lightbars = {
    {label = 'Slimfit Frontblitzer Rot/Blau', spawn_code = 'lightbartwosticks', extras = {}},

    {label = 'OneGuard Frontblitzer Rot/Blau (Frei)', spawn_code = 'D3s_DualGuard', extras = {1}},
    {label = 'OneGuard Frontblitzer Rot/Blau (Mount)', spawn_code = 'D3s_DualGuard', extras = {1, 11, 12}},
    {label = 'OneGuard Frontblitzer Rot/Weiß (Frei)', spawn_code = 'D3s_DualGuard', extras = {3}},
    {label = 'OneGuard Frontblitzer Rot/Weiß (Mount)', spawn_code = 'D3s_DualGuard', extras = {3, 11, 12}},
    {label = 'OneGuard Frontblitzer Orange/Weiß (Frei)', spawn_code = 'D3s_DualGuard', extras = {5}},
    {label = 'OneGuard Frontblitzer Orange/Weiß (Mount)', spawn_code = 'D3s_DualGuard', extras = {5, 11, 12}},

    {label = 'Siderunner Rot/Blau', spawn_code = 'D3s_SideRunners_B', extras = {1}},

    {label = 'Traffic Board', spawn_code = 'D3sDotBoard', extras = {7, 9}, sign = true},

    {label = 'Visorlights Rot/Blau', spawn_code = 'D3s_VisorV1RB', extras = {1}},
    {label = 'Visorlights Rot/Rot', spawn_code = 'D3s_VisorV1RR', extras = {1}},

    {label = 'Coupe Pushbar Rot/Blau', spawn_code = 'D3s_Pbar_Coupe2', extras = {1, 11}},
    {label = 'Coupe Pushbar Rot/Weiß', spawn_code = 'D3s_Pbar_Coupe2', extras = {1, 11}},
    {label = 'Coupe Pushbar Orange/Weiß', spawn_code = 'D3s_Pbar_Coupe2', extras = {1, 11}},

    {label = 'Muscle Pushbar Rot/Blau', spawn_code = 'D3s_Pbar_Muscle2', extras = {1, 11}},
    {label = 'Muscle Pushbar Rot/Weiß', spawn_code = 'D3s_Pbar_Muscle2', extras = {1, 11}},
    {label = 'Muscle Pushbar Orange/Weiß', spawn_code = 'D3s_Pbar_Muscle2', extras = {1, 11}},

    {label = 'SUV Pushbar Rot/Blau', spawn_code = 'D3s_Pbar_SUV', extras = {1, 11}},
    {label = 'SUV Pushbar Rot/Weiß', spawn_code = 'D3s_Pbar_SUV', extras = {1, 11}},
    {label = 'SUV Pushbar Orange/Weiß', spawn_code = 'D3s_Pbar_SUV', extras = {1, 11}},

    {label = 'Truck Pushbar Rot/Blau', spawn_code = 'D3s_Pbars_Truck', extras = {1, 11}},
    {label = 'Truck Pushbar Rot/Weiß', spawn_code = 'D3s_Pbars_Truck', extras = {1, 11}},
    {label = 'Truck Pushbar Orange/Weiß', spawn_code = 'D3s_Pbars_Truck', extras = {1, 11}},

}

Config.Controls = {
    PoliceLights = 'Q', 
    policeHorn   = 'E',
    sirenToggle  = 'LMENU',
    sirenCycle   = 'R',
}

Config.Sirens = {
    ['1'] = {
        horn = {string = 'SIRENS_AIRHORN', ref = 0},
        siren1 = {string = 'VEHICLES_HORNS_SIREN_1', ref = 0},
        siren2 = {string = 'VEHICLES_HORNS_SIREN_2', ref = 0},
        siren3 = {string = 'VEHICLES_HORNS_POLICE_WARNING', ref = 0},
    },
    ['2'] = {
        horn = {string = 'GAMMA_AIRHORN', ref = 'WHELENGAMMA2_SOUNDSET'},
        siren1 = {string = 'GAMMA_WAIL', ref = 'WHELENGAMMA2_SOUNDSET'},
        siren2 = {string = 'GAMMA_YELP', ref = 'WHELENGAMMA2_SOUNDSET'},
        siren3 = {string = 'GAMMA_WARN', ref = 'WHELENGAMMA2_SOUNDSET'},
    },
    ['3'] = {
        horn = {string = 'FIRE_HORN', ref = 'FIREEMS_SOUNDSET'},
        siren1 = {string = 'FIRE_WAIL', ref = 'FIREEMS_SOUNDSET'},
        siren2 = {string = 'FIRE_YELP', ref = 'FIREEMS_SOUNDSET'},
        siren3 = {string = 'FIRE_POWERCALL', ref = 'FIREEMS_SOUNDSET'},
    },
    ['4'] = {
        horn = {string = 'PA_AIRHORN', ref = 'FEDSIGPA4000_SOUNDSET'},
        siren1 = {string = 'PA_WAIL', ref = 'FEDSIGPA4000_SOUNDSET'},
        siren2 = {string = 'PA_YELP', ref = 'FEDSIGPA4000_SOUNDSET'},
        siren3 = {string = 'PA_WARNING', ref = 'FEDSIGPA4000_SOUNDSET'},
    },
    ['5'] = {
        horn = {string = 'DX5HORN', ref = 'DX5_SOUNDSET'},
        siren1 = {string = 'DX5WAIL', ref = 'DX5_SOUNDSET'},
        siren2 = {string = 'DX5YELP', ref = 'DX5_SOUNDSET'},
        siren3 = {string = 'DX5INTER', ref = 'DX5_SOUNDSET'},
    },
}

Config.MoveSpeed = {
    ['1'] = 0.01,
    ['2'] = 0.05,
    ['3'] = 0.10,
    ['4'] = 0.15,
    ['5'] = 0.20,
    ['6'] = 0.25,
    ['7'] = 0.30,
    ['8'] = 0.35,
    ['9'] = 0.40,
    ['10'] = 0.45,
}

Config.RotationSpeed = {
    ['1'] = 1,
    ['2'] = 2,
    ['3'] = 3,
    ['4'] = 4,
    ['5'] = 5,
    ['6'] = 6,
    ['7'] = 7,
    ['8'] = 8,
    ['9'] = 9,
    ['10'] = 10,
}

Config.Language = 'DE'
Config.Locales = {
    ['DE'] = {
        ['menu'] = {
            header = 'Lightbar Menü',
            add_lights = 'Lichter Hinzufügen',
            add_lights_desc = 'Baue weitere Blaulichter an deinem Fahrzeug an',
            del_lights = 'Lichter Entfernen',
            del_lights_desc = 'Entferne bestehende Lichter von deinem Fahrzeug',
            save_lights = 'Lichter Speichern',
            save_lights_desc = 'Speichere dein Licht Setup',
            board = 'Traffic Board',
            board_desc = 'Bearbeite dein Traffic Board',

            edit_board = 'Klappen',
            edit_board_desc = 'Klappe das Traffic Board ein/aus', 
            board_1 = 'Road Closed',
            board_2 = 'Arrow Right',
            board_3 = 'Arrow Left',
            board_4 = 'Checkpoint Ahead',
            board_5 = 'EOTS',
            board_6 = 'Event Parking',
            board_edit = 'Dieses Schild anzeigen',

            save_plate = 'Auf Kennzeichen Speichern',
            save_plate_desc = 'Speichere das Light Setup auf das Kennzeichen',
            place_plate = 'Licht von Kennzeichen anbauen',
            place_plate_desc = 'Baue das Light Setup des Kennzeichens an',
        },

        ['checkmark'] = {
            ['on'] = '✔️',
            ['off'] = '✖️',
        },

        ['add_lights_help_header'] = 'Lichter Plazieren',
        ['add_lights_help'] = '[BACK] - Menü schließen   \n   [ENTER] - Lichter Anbauen   \n   [WASD] - Lichter Bewegen   \n   [↑↓] - Höhe Ändern   \n   [←→] Lichter Drehen   \n   [BILD↑↓] - Licht Wählen   \n   [LEER] - Licht Clonen',
    
        ['add_lights_settings_header'] = 'Aktuelle Einstellungen',
        ['add_lights_settings'] = 'Model: %s   \n   Geschwindigkeit: %s   \n   XYZ: %s %s %s   \n   Rot: %s   \n   Clone: %s',
    },
    ['EN'] = {
    },
}
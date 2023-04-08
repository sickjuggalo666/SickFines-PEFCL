Config = {}

Config.PoliceJobs = {
    ['police'] = true,
    ['bcso'] = true,
}

Config.Jobs = {
    [1] = {
        name = 'police',
        rank = 0,
        coords = vector3(483.4407, -983.6334, 26.2734),
        id = 'police_tickets',
        label = 'Police Tickets',
        slots = 150,
        maxWeight = 1000000,
    },

    [2] = {
        name = 'bcso',
        rank = 0,
        coords = vector3(487.4940, -992.4795, 26.2734),
        id = 'sheriff_tickets',
        label = 'Sheriff Tickets',
        slots = 20,
        maxWeight = 10000,
    }
}

Config.Notifications = {
    Client = 'okok',
    Server = 'okok'
}
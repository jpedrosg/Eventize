//
//  Copyright © Uber Technologies, Inc. All rights reserved.
//


import Foundation

final class JsonMocks {
    static let Event_EventDetails: Data? = """
    {
        "description": "Venha se juntar a nós em uma noite de pura música e talento na grande festa da FIAP! Este evento espetacular trará alguns dos cantores mais talentosos do país para o palco, proporcionando uma experiência musical inigualável. Desfrute de performances incríveis, desde o pop mais atual até as clássicas baladas que aquecem o coração."
    }
    """.data(using: .utf8)
    
    static let Events_EventObject_Array: Data? = """
    [
        {
            "event_uuid": "1",
            "content": {
                "image_url": null,
                "title": "Concert: Rock Night",
                "subtitle": "123 Main Street",
                "price": 25.99,
                "info": "Batch 2",
                "extra_bottom_info": [
                    {
                        "image_url": null,
                        "text": "Elvis"
                    }
                ]
            }
        },
        {
            "event_uuid": "2",
            "content": {
                "image_url": null,
                "title": "Movie Night: Sci-Fi Marathon",
                "subtitle": "456 Elm Avenue",
                "price": 12.5,
                "info": "All Ages",
                "extra_bottom_info": [
                    {
                        "image_url": null,
                        "text": "Alicia"
                    }
                ]
            }
        },
        {
            "event_uuid": "3",
            "content": {
                "image_url": null,
                "title": "Food Festival: International Flavors",
                "subtitle": "789 Oak Road",
                "price": 15.0,
                "info": "+18",
                "extra_bottom_info": [
                    {
                        "image_url": null,
                        "text": "Michael"
                    }
                ]
            }
        },
        {
            "event_uuid": "4",
            "content": {
                "image_url": null,
                "title": "Art Exhibition: Modern Masterpieces",
                "subtitle": "101 Art Street",
                "price": 0.0,
                "info": "VIP Only",
                "extra_bottom_info": [
                    {
                        "image_url": null,
                        "text": "Eva"
                    }
                ]
            }
        },
        {
            "event_uuid": "5",
            "content": {
                "image_url": null,
                "title": "Sports Event: Soccer Championship",
                "subtitle": "222 Stadium Lane",
                "price": 30.75,
                "info": "Family Friendly",
                "extra_bottom_info": [
                    {
                        "image_url": null,
                        "text": "David"
                    }
                ]
            }
        },
        {
            "event_uuid": "6",
            "content": {
                "image_url": null,
                "title": "Comedy Show: Stand-up Night",
                "subtitle": "333 Laugh Avenue",
                "price": 18.5,
                "info": "18+",
                "extra_bottom_info": [
                    {
                        "image_url": null,
                        "text": "Sarah"
                    }
                ]
            }
        },
        {
            "event_uuid": "7",
            "content": {
                "image_url": null,
                "title": "Tech Conference: Innovation Summit",
                "subtitle": "444 Tech Road",
                "price": 0.0,
                "info": "By Invitation",
                "extra_bottom_info": [
                    {
                        "image_url": null,
                        "text": "John"
                    }
                ]
            }
        },
        {
            "event_uuid": "8",
            "content": {
                "image_url": null,
                "title": "Fashion Show: Couture Collection",
                "subtitle": "555 Runway Street",
                "price": 50.0,
                "info": "VIP Only",
                "extra_bottom_info": [
                    {
                        "image_url": null,
                        "text": "Lily"
                    }
                ]
            }
        },
        {
            "event_uuid": "9",
            "content": {
                "image_url": null,
                "title": "Science Fair: Exploration Expo",
                "subtitle": "666 Lab Lane",
                "price": 0.0,
                "info": "All Ages",
                "extra_bottom_info": [
                    {
                        "image_url": null,
                        "text": "Ethan"
                    }
                ]
            }
        },
        {
            "event_uuid": "10",
            "content": {
                "image_url": null,
                "title": "Dance Party: Disco Fever",
                "subtitle": "777 Groove Street",
                "price": 20.0,
                "info": "18+",
                "extra_bottom_info": [
                    {
                        "image_url": null,
                        "text": "Mia"
                    }
                ]
            }
        }
    ]
    """.data(using: .utf8)
}

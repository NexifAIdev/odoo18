# -*- coding: utf-8 -*-
{
    "name": "Customer Support",
    "summary": "Custom Support Ticket System",
    "description": """
Custom Support Ticket
==========================
This module was developed in-house to manage support ticket workflows 
tailored for MiEN's internal operations.
""",
    "author": "Jasper Daguplo",
    "category": "Custom Development",
    "version": "18.0.1.0.0",
    "depends": ['base','mail', ],
    "data": [
        'security/customer_support_groups.xml',
        'security/ir.model.access.csv',
        'data/support_ticket_sequence.xml',
        'views/support_ticket.xml',
        'views/support_ticket_menu.xml',

    ],
    "license": "OEEL-1",
    "icon": "/nexifai_customer_support/static/src/description/icon.png",
    "installable": True,
    "application": True,
}

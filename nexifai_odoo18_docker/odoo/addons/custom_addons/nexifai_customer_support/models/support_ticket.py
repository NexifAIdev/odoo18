from odoo import models, fields, api
from dateutil.relativedelta import relativedelta
from odoo.exceptions import ValidationError

class SupportTicket(models.Model):
    _name = 'support.ticket'
    _inherit = ['mail.thread', 'mail.activity.mixin']
    _description = 'Support Ticket'

    name = fields.Char(string='Title', required=True, tracking=True, copy=False, default='New', readonly=True)
    description = fields.Text(string='Description')
    state = fields.Selection([
        ('new', 'New'),
        ('in_progress', 'In Progress'),
        ('resolved', 'Resolved'),
        ('closed', 'Closed')
    ], default='new', string='State', tracking=True)
    priority = fields.Selection([
        ('low', 'Low'),
        ('medium', 'Medium'),
        ('high', 'High')
    ], string='Priority', tracking=True)
    client_id = fields.Many2one('res.partner', string='Client')
    assigned_to = fields.Many2one('res.users', string='Assigned To', tracking=True)
    uat_phase = fields.Selection([
        ('initial_test', 'Initial Test'),
        ('feedback', 'Feedback'),
        ('retest', 'Retest')
    ], string='UAT Phase', tracking=True)
    test_results = fields.Text(string='Test Results')

    @api.model
    def create(self, vals):
        if vals.get('name', 'New') == 'New':
            vals['name'] = self.env['ir.sequence'].next_by_code('support.ticket') or '/'
        record = super(SupportTicket, self).create(vals)

        # Post to chatter
        record.message_post(
            body=f"<b>New support ticket created</b><br/>Assigned to: {record.assigned_to.name or 'Unassigned'}",
            subtype_xmlid="mail.mt_note"
        )

        # Schedule activity
        record.activity_schedule(
            'mail.mail_activity_data_todo',
            user_id=self.env.user.id,
            summary="Initial Review",
            note="Please start reviewing the ticket."
        )

        return record
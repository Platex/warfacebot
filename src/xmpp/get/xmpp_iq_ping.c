/**
 * WarfaceBot, a blind XMPP client for Warface (FPS)
 * Copyright (C) 2015 Levak Borok <levak92@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#include <wb_xmpp.h>
#include <wb_session.h>
#include <wb_stream.h>

static void xmpp_iq_ping_cb(const char *msg, void *args)
{
    /* Answer :
      <iq from='warface' id='ping_1' type='result'/>
    */

    if (xmpp_is_error(msg))
        return;
}

void xmpp_iq_ping(void)
{
    t_uid id;

    idh_generate_unique_id(&id);
    idh_register(&id, 0, xmpp_iq_ping_cb, NULL);

    send_stream_format(session.wfs,
                       "<iq id='%s' from='%s' to='warface' type='get'>"
                       " <ping xmlns='urn:xmpp:ping'/>"
                       "</iq>",
                       &id, session.jid);
}


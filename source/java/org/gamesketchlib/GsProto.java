package org.gamesketchlib;

/**
 * Root class for all of our objects.
 * Defines a simple message-passing protocol.
 */
public abstract class GsProto
{
    /* A generic (untyped) message-passing protocol for
     * communicating between objects.
     *
     * Message codes are unique ints and should be created
     * with Game.newMessageCode();
     */
    void message(GsProto sender, int code, Object arg)
    {
    }
}

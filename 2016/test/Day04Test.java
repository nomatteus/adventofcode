import org.junit.Test;

import java.util.Scanner;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

/**
 * Created by matt on 2016-12-21.
 */
public class Day04Test {

    @Test
    public void testDay01_Part1() {
        Day04 day4 = new Day04();
        // My tests
        // Sample cases from problem
        assertEquals("abxyz", (new Day04.Room("aaaaa-bbb-z-y-x-123[abxyz]").getChecksum()));
        assertEquals("abcde", (new Day04.Room("a-b-c-d-e-f-g-h-987[abcde]").getChecksum()));
        assertEquals("oarel", (new Day04.Room("not-a-real-room-404[oarel]").getChecksum()));
        assertEquals("loart", (new Day04.Room("totally-real-room-200[decoy]").getChecksum()));

        assertTrue((new Day04.Room("aaaaa-bbb-z-y-x-123[abxyz]").isRealRoom()));
        assertTrue((new Day04.Room("a-b-c-d-e-f-g-h-987[abcde]").isRealRoom()));
        assertTrue((new Day04.Room("not-a-real-room-404[oarel]").isRealRoom()));
        assertFalse((new Day04.Room("totally-real-room-200[decoy]").isRealRoom()));

        assertEquals(1514, day4.sumSectorIdsOfRealRooms("aaaaa-bbb-z-y-x-123[abxyz]\n" +
                "a-b-c-d-e-f-g-h-987[abcde]\n" +
                "not-a-real-room-404[oarel]\n" +
                "totally-real-room-200[decoy]"));
    }
}

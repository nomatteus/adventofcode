import org.junit.Test;

import static junit.framework.Assert.assertEquals;

/**
 * Created by matt on 2016-12-23.
 */
public class Day08Test {
    @Test
    public void test_Day07() {
        // Small rectangle for testing.
        Day08 day8 = new Day08(7, 3);
        // Basic string output
        assertEquals(".......\n" +
                              ".......\n" +
                              ".......\n", day8.toString());
        assertEquals(0, day8.getNumPixelsOn());
        // drawing a rectangle
        day8.rect(3, 2);
        assertEquals("###....\n" +
                              "###....\n" +
                              ".......\n", day8.toString());
        // rotate column
        day8.rotateColumn(1, 1);
        assertEquals("#.#....\n" +
                              "###....\n" +
                              ".#.....\n", day8.toString());
        // rotate row
        day8.rotateRow(0, 4);
        assertEquals("....#.#\n" +
                              "###....\n" +
                              ".#.....\n", day8.toString());
        // rotate col
        day8.rotateColumn(1, 1);
        assertEquals(".#..#.#\n" +
                              "#.#....\n" +
                              ".#.....\n", day8.toString());
        assertEquals(6, day8.getNumPixelsOn());
        // more.
        day8.rect(6, 2);
        assertEquals("#######\n" +
                              "######.\n" +
                              ".#.....\n", day8.toString());
        assertEquals(14, day8.getNumPixelsOn());


        // Bigger rectangle to ensure this works with other sizes
        Day08 day8bigger = new Day08(30, 7);
        day8bigger.rect(16, 5);
        day8bigger.rotateRow(1, 14);
        day8bigger.rotateRow(3, 14);
        day8bigger.rotateColumn(1, 1);
        day8bigger.rotateColumn(5, 3);
        assertEquals( "#.##############..............\n" +
                               ".#............################\n" +
                               "#.###.##########..............\n" +
                               ".#...#........################\n" +
                               "#.###.##########..............\n" +
                               ".#...#........................\n" +
                               "..............................\n", day8bigger.toString());
        assertEquals(80, day8bigger.getNumPixelsOn());
    }

}

import org.junit.Test;
import static junit.framework.Assert.assertEquals;

/**
 * Created by matt on 2016-12-26.
 */
public class Day09Test {
    @Test
    public void test_Day09() {
        Day09 day9 = new Day09();
        // Examples from day 9
//        assertEquals("ABBBBBC", day9.decompressedString("A(1x5)BC"));
//        assertEquals(7, day9.decompressedLength("A(1x5)BC"));
        assertEquals("XYZXYZXYZ", day9.decompressedString("(3x3)XYZ"));
        assertEquals(9, day9.decompressedLength("(3x3)XYZ"));
        assertEquals("ADVENT", day9.decompressedString("ADVENT"));
        assertEquals(6, day9.decompressedLength("ADVENT"));
        assertEquals("ABCBCDEFEFG", day9.decompressedString("A(2x2)BCD(2x2)EFG"));
        assertEquals(11, day9.decompressedLength("A(2x2)BCD(2x2)EFG"));
        assertEquals("(1x3)A", day9.decompressedString("(6x1)(1x3)A"));
        assertEquals(6, day9.decompressedLength("(6x1)(1x3)A"));
        assertEquals("X(3x3)ABC(3x3)ABCY", day9.decompressedString("X(8x2)(3x3)ABCY"));
        assertEquals(18, day9.decompressedLength("X(8x2)(3x3)ABCY"));
    }
}

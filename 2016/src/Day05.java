import java.math.BigInteger;
import java.security.MessageDigest;
import java.util.HashMap;
import java.util.TreeMap;

/**
 * Created by matt on 2016-12-21.
 */
public class Day05 {

    MessageDigest md;

    public Day05() throws  Exception {
        md = MessageDigest.getInstance("MD5");
    }

    // Returns if the first 5 hex digits of md5 are 0 for the given input
    public boolean first5hexZero(byte[] input) {
        // check the first 2.5 bytes (aka first 5 hex chars = 4*5=20 bits)
        boolean first5hexZero = input[0] == 0 && input[1] == 0 && (input[2] >> 4) == 0;
        return first5hexZero;
    }

    public byte[] md5(String input) {
        md.reset();
        return md.digest(input.getBytes());
    }

    public String password_part1(String doorId) throws Exception {
        int currentInt = 0;
        StringBuilder password = new StringBuilder();
        while (password.length() < 8) {
            String hashInput = doorId + currentInt;
            byte[] md5 = md5(hashInput);
            if (first5hexZero(md5)) {
//                System.out.println("Found interesting int: " + currentInt);
                byte[] interestingDigit = new byte[1];
                interestingDigit[0] = md5[2]; // we know that it starts with 0 so just use as-is
                BigInteger interestingDigitBig = new BigInteger(1, interestingDigit);
                String digitStr = interestingDigitBig.toString(16);
                password.append(digitStr);
            }
            currentInt++;
        }
        return password.toString();
    }

    public String password_part2(String doorId) throws Exception {
        int currentInt = 0;
        // This time, store password as a treemap of position (0-7) and character.
        // Once position is filled, we do not update it.
        // And loop until the treemap has 8 entries
        TreeMap<Integer, String> password = new TreeMap<>();

        while (password.size() < 8) {
            String hashInput = doorId + currentInt;
            byte[] md5 = md5(hashInput);
            if (first5hexZero(md5)) {
                BigInteger md5Big = new BigInteger(1, md5);
//                String md5Str = md5Big.toString(16);
                String md5Str = String.format("%032x" ,md5Big); // pad with 0s to length 32
                Integer position = Integer.parseInt(md5Str.substring(5,6), 16);
                // Valid positions are only 0-7, and also ensure position not already filled
                if (position < 8 && !password.containsKey(position)) {
                    // 7th is the character
                    String letter = md5Str.substring(6,7);

                    // DEBUG info:
                    // System.out.println(String.format("At int %d, putting %s into pos %d (hash is %s)", currentInt, letter, position, md5Str));
                    password.put(position, letter);
                }
            }
            currentInt++;
        }
        return String.join("", password.values());
    }

    public static void main(String[] args) throws Exception{
        Day05 day5 = new Day05();
        // Puzzle input
        String input = "ffykfhsq";

        System.out.print("--> Part 1: ");
        System.out.println(day5.password_part1(input));
        System.out.print("--> Part 2: ");
        System.out.println(day5.password_part2(input));
    }
}

import java.math.BigInteger;
import java.security.MessageDigest;

/**
 * Created by matt on 2016-12-21.
 */
public class Day05 {

    public String password(String doorId) throws Exception {
        // pseudo-code
        /*
        currentInt = 0; // start at 0
        password = "";
        while (password length < 8) {
            hash = md5 (doorId + currentInt)
            if (hash starts with 5 0s) {
                password.append(6th character of hash)
            }
            currentInt++
        }
        return password;
         */
        MessageDigest md = MessageDigest.getInstance("MD5");
        int currentInt = 0;
        StringBuilder password = new StringBuilder();
        while (password.length() < 8) {
            String hashInput = doorId + currentInt;
            md.reset();
            // Some messy code here.. not used to working with bytes in java...
            byte[] digest = md.digest(hashInput.getBytes());
            // check the first 2.5 bytes (aka first 5 hex chars = 4*5=20 bits)
            byte zero = (byte) 0b0;
            boolean first5hexZero = digest[0] == 0 && digest[1] == 0 && (digest[2] >> 4) == 0;

            if (first5hexZero) {
//                System.out.println("Found interesting int: " + currentInt);
                byte[] interestingDigit = new byte[1];
                interestingDigit[0] = digest[2]; // we know that it starts with 0 so just use as-is
                BigInteger interestingDigitBig = new BigInteger(1, interestingDigit);
                String digitStr = interestingDigitBig.toString(16);
                password.append(digitStr);
            }
            currentInt++;
        }
        return password.toString();
    }

    public static void main(String[] args) throws Exception{
        Day05 day5 = new Day05();
        // Puzzle input
        String input = "ffykfhsq";

        System.out.print("--> Part 1: ");
        System.out.println(day5.password(input));
//        System.out.print("--> Part 2: ");
//        System.out.println(day5.password(input));
    }
}

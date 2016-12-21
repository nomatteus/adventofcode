import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.io.*;
import java.nio.ByteBuffer;
import java.math.BigInteger;

public class AdventCoins {
  public static byte[] md5(MessageDigest md, byte[] input) {
    md.update(input);
    byte[] digest = md.digest();
    return digest;
  }

  public static String byteToString(byte[] digest) {
    return String.format("%032x", new BigInteger(1, digest));
  }

  // work with md5s as strings for now, becuase it's easier.
  // but probably a lot faster to work with bytes and bits, so consider that if speedup needed
  public static void part1() throws UnsupportedEncodingException {
    MessageDigest md = null;
    try {
      md = MessageDigest.getInstance("md5");
    } catch (NoSuchAlgorithmException e) {
      e.printStackTrace();
    }
    byte[] secretKey = null;
    secretKey = "iwrupvqb".getBytes("UTF-8");
    for (int i=1; i<Integer.MAX_VALUE; i++) {
      byte[] iBytes = Integer.toString(i).getBytes("UTF-8");
      byte[] hashInput = new byte[secretKey.length + iBytes.length];
      for (int j=0; j < hashInput.length;j++) {
        if (j < secretKey.length)
          hashInput[j] = secretKey[j];
        else
          hashInput[j] = iBytes[j - secretKey.length];
      }
      byte[] hash = AdventCoins.md5(md, hashInput);
      String hashStr = byteToString(hash);
      if (hashStr.charAt(0) == '0' && hashStr.charAt(1) == '0' && hashStr.charAt(2) == '0'
          && hashStr.charAt(3) == '0' && hashStr.charAt(4) == '0') {
        System.out.println(String.format("\t%d\t%s", i, hashStr));
        return;
      }
    }
  }

  public static void part2() throws UnsupportedEncodingException{
    long startTime = System.currentTimeMillis();
    MessageDigest md = null;
    try {
      md = MessageDigest.getInstance("md5");
    } catch (NoSuchAlgorithmException e) {
      e.printStackTrace();
    }
    byte[] secretKey = null;
    secretKey = "iwrupvqb".getBytes("UTF-8");
    for (int i=1; i<Integer.MAX_VALUE; i++) {
      byte[] iBytes = Integer.toString(i).getBytes("UTF-8");
      byte[] hashInput = new byte[secretKey.length + iBytes.length];
      for (int j=0; j < hashInput.length;j++) {
        if (j < secretKey.length)
          hashInput[j] = secretKey[j];
        else
          hashInput[j] = iBytes[j - secretKey.length];
      }
      byte[] hash = AdventCoins.md5(md, hashInput);
      String hashStr = byteToString(hash);
      if (hashStr.charAt(0) == '0' && hashStr.charAt(1) == '0' && hashStr.charAt(2) == '0'
          && hashStr.charAt(3) == '0' && hashStr.charAt(4) == '0' && hashStr.charAt(5) == '0') {
        System.out.println(String.format("\t%d\t%s", i, hashStr));
        return;
      }
      // if (i%1000000 == 0) {
      //   System.out.println(i + "...");
      //   // debugging time spent...
      //   long endTime = System.currentTimeMillis();
      //   System.out.println("\tMillion checked in: " + (endTime - startTime) + " ms");
      //   startTime = endTime;
      // }
    }
  }

  public static void main(String[] args) throws UnsupportedEncodingException {
    System.out.println("----- Part 1");
    AdventCoins.part1();
    System.out.println("----- Part 2");
    AdventCoins.part2();
  }
}

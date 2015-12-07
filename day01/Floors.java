import java.io.*;

public class Floors {

  public static BufferedReader buffReaderForFile(String filename) {
    FileReader fileReader = null;
    try {
      fileReader = new FileReader(filename);
    } catch (FileNotFoundException e) {
      e.printStackTrace();
    }
    return new BufferedReader(fileReader);
  }

  public static void main(String[] args) throws IOException {
    BufferedReader buffer = Floors.buffReaderForFile("input");
    int curFloor = 0;

    int c = 0;
    int position = 1;
    // Position of character when santa first enters basement.
    int basementPosition = -1;
    while((c = buffer.read()) != -1) {
      char character = (char) c;
      switch (character) {
        case '(':
          curFloor++;
          break;
        case ')':
          curFloor--;
          break;
      }
      // Is santa entering basement for first time?
      if (basementPosition == -1 && curFloor == -1) {
        basementPosition = position;
      }

      position++;
    }

    System.out.println("----- Part 1");
    System.out.println(String.format("Santa is on floor %d", curFloor));
    System.out.println("----- Part 2");
    System.out.println(String.format("Santa first entered basement at position %d", basementPosition));

  }
}

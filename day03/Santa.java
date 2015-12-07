import java.io.*;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Arrays;

public class Santa {
  public int[] current = {0, 0};
  HashSet<List<Integer>> visitedCoords = new HashSet<>();

  public Santa(int startX, int startY) {
    current[0] = startX;
    current[1] = startY;
    addMove(current[0], current[1]);
  }

  public void move(char command) {
    switch(command) {
      case '^':
        current[0]++;
        break;
      case '>':
        current[1]++;
        break;
      case '<':
        current[1]--;
        break;
      case 'v':
        current[0]--;
        break;
      default:
        // invalid char.
        break;
    }
    addMove(current[0], current[1]);
  }

  private void addMove(int x, int y) {
    visitedCoords.add(Arrays.asList(new Integer(x), new Integer(y)));
  }

  public HashSet<List<Integer>> getVisitedCoords() {
    return visitedCoords;
  }

  public static void main(String[] args) throws IOException {
    // Start at 0,0 (note that actual starting position is not important)
    Santa santa = new Santa(0, 0);

    FileReader fileReader = null;
    try {
      fileReader = new FileReader("input");
    } catch (FileNotFoundException e) {
      e.printStackTrace();
    }
    BufferedReader buffer = new BufferedReader(fileReader);
    int c = 0;
    while((c = buffer.read()) != -1) {
      char character = (char) c;
      santa.move(character);
    }

    HashSet<List<Integer>> result = santa.getVisitedCoords();
    Iterator<List<Integer>> iter = result.iterator();
    while (iter.hasNext()) {
      List<Integer> coord = iter.next();
      System.out.println(String.format("visited: (%d,%d)", coord.get(0), coord.get(1)));
    }
    System.out.println(String.format("Total houses visited: %d", result.size()));

  }
}

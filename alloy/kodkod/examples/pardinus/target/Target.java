package kodkod.examples.pardinus.target;
import java.io.BufferedReader;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;
import java.io.InputStream;
import java.io.InputStreamReader;


public class Target {
	
	public static void main(String[] args) throws Exception {
		int i,j;
		int size = Integer.parseInt(args[1]);
		
		Path path = FileSystems.getDefault().getPath("", args[0]);
		InputStream in = Files.newInputStream(path);
		
	    BufferedReader reader = new BufferedReader(new InputStreamReader(in));
	    String line = null;
	    line = reader.readLine();
	    String[] header = line.split(" ");
	    System.out.println("p wcnf "+header[2]+" "+(Integer.parseInt(header[3])+(size*size))+" "+(size*size+1));
	    
	    while ((line = reader.readLine()) != null) {
	        System.out.println((size*size+1)+" "+line);
	    }		
		for (i=0;i<size;i++) {
			for (j=1;j<=size;j++) {
				if (i==j-1) {
					System.out.println("1 "+(i*size+j)+" 0");
				} else {
					System.out.println("1 -"+(i*size+j)+" 0");
				}
			}
		}
	}
}

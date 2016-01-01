/**
 * 
 */
package my.project;

import java.io.FileInputStream;

/**
 * 
 * @author Denilson Nastacio
 */
public class Instrumented
{

    private static final int MEASURED_ITERATIONS = 1000;
    private static final int WARM_UP_ITERATIONS = 100000;

    public void print() throws Exception
    {
        Thread.sleep(0, 1000);
        FileInputStream f = new FileInputStream("file.txt");
        f.close();
    }

    /**
	 * 
	 */
    public void doSomething() throws Exception
    {
        System.out.println("warming up.");
        long startTime = System.currentTimeMillis();
        for (int i = 0; i < WARM_UP_ITERATIONS; i++)
        {
            print();
        }
        long endTime = System.currentTimeMillis();
        System.out.println("Warm up duration: " + (endTime - startTime));

        startTime = System.currentTimeMillis();
        for (int i = 0; i < MEASURED_ITERATIONS; i++)
        {
            print();
        }
        endTime = System.currentTimeMillis();
        System.out.println("Elapsed microseconds: " + (endTime - startTime));
    }

    /**
     * @param args
     */
    public static void main(String[] args)
    {
        Instrumented id = new Instrumented();
        try
        {
            id.doSomething();
        } catch (Exception e)
        {
            // TODO Auto-generated catch block
        }
    }

}

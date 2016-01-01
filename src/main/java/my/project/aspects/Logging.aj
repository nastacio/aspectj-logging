package my.project.aspects;

import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Aspect for Java logging throughout the code base.
 */
public aspect Logging pertypewithin(my..* && !Exception+) {

	private static Logger trace = Logger.getLogger("trace.my.project");

	/*
	 * Pointcuts
	 */

	/**
	 * Initialization of all classes in the project.
	 */
	pointcut classInitializer() :
    	staticinitialization(my.project..*) &&
        !within(Logging);

	/**
	 * Execution body for all methods.
	 */
	pointcut method():
        (
          execution(my.project..*.new(..)) ||
          execution(* my.project..*.*(..))
        )
        && !within(my.project.D.*) 
        && !within(Logging);

	/**
	 * Exception handling blocks inside all methods.
	 */
	pointcut methodError():
        handler(Throwable+) &&
        !handler(InterruptedException+) &&
        !within(Logging);

	/*
	 * Join points
	 */

	/**
	 * After the initialization for all classes in this project.
	 */
	after(): classInitializer() {
		String classname = thisJoinPointStaticPart.getSourceLocation()
				.getWithinType().getName();
		trace = Logger.getLogger("trace." + classname);
	}

	/**
	 * Entry trace statements for all methods.
	 */
	before(): method() {
		if (trace.isLoggable(Level.FINER)) {
			trace.entering(thisJoinPointStaticPart.getSourceLocation()
					.getWithinType().getName(), thisJoinPointStaticPart
					.getSignature().toString(), thisJoinPoint.getArgs());
		}
	}

	/**
	 * Exit trace statements for all methods.
	 */
	after() returning (Object result): method() {
		if (trace.isLoggable(Level.FINER)) {
			trace.exiting(thisJoinPointStaticPart.getSourceLocation()
					.getWithinType().getName(), thisJoinPointStaticPart
					.getSignature().toString(), result);
		}
	}
	
	after() throwing(Throwable e) : method() {
        if (trace.isLoggable(Level.FINE)) {
            trace.throwing(thisJoinPointStaticPart.getSourceLocation()
                    .getWithinType().getName(), thisJoinPointStaticPart
                    .getSignature().toString(), e);
        }
	}

	/**
	 * Exception handling blocks inside all methods.
	 */
	before(): methodError() {
		if (trace.isLoggable(Level.FINER)) {
			Object target = thisJoinPoint.getArgs()[0];
			trace.logp(Level.FINER, thisJoinPointStaticPart
					.getSourceLocation().getWithinType().getName(),
					thisJoinPointStaticPart.getSignature().toLongString(),
					"Caught exception: " + target.getClass().toString(),
					(Throwable) target);
		}
	}

}
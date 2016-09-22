package com.scdeco.miniataweb.util;

import java.util.HashMap;
import java.util.Map;

import org.hibernate.transform.AliasedTupleSubsetResultTransformer;
import org.hibernate.transform.ResultTransformer;

/**
 * {@link ResultTransformer} implementation which builds a map for each "row",
 * made up  of each aliased value where the alias is the map key.
 * <p/>
 * Since this transformer is stateless, all instances would be considered equal.
 * So for optimization purposes we limit it to a single, singleton {@link #INSTANCE instance}.
 *
 * @author Gavin King
 * @author Steve Ebersole
 * 
 * Make the first letter of result field lowercase. 
 * The constructor of original class is private and can not be extended, so have to copy to here and add a few lines. 
 */
@SuppressWarnings("serial")
public class CliviaAliasToEntityMapResultTransformer extends
		AliasedTupleSubsetResultTransformer {

	public static final CliviaAliasToEntityMapResultTransformer INSTANCE = new CliviaAliasToEntityMapResultTransformer();

	/**
	 * Disallow instantiation of AliasToEntityMapResultTransformer.
	 */
	private CliviaAliasToEntityMapResultTransformer() {
	}


	@SuppressWarnings("unchecked")
	@Override
	public Object transformTuple(Object[] tuple, String[] aliases) {
		@SuppressWarnings("rawtypes")
		Map result = new HashMap(tuple.length);
		for ( int i=0; i<tuple.length; i++ ) {
			String alias = aliases[i];
			if ( alias!=null ) {
				
				//added by Jacob
				char c[] = alias.toCharArray();
				int j=0;
				while(j<c.length && Character.isUpperCase(c[j])){
					c[j] = Character.toLowerCase(c[j]);
					j++;
				}
				alias=new String(c);
				
				result.put(alias , tuple[i] );
			}
		}
		return result;
	}

	@Override
	public boolean isTransformedValueATupleElement(String[] aliases, int tupleLength) {
		return false;
	}

	/**
	 * Serialization hook for ensuring singleton uniqueing.
	 *
	 * @return The singleton instance : {@link #INSTANCE}
	 */
	private Object readResolve() {
		return INSTANCE;
	}	
	
}

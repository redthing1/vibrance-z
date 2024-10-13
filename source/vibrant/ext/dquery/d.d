
module vibrant.ext.dquery.d;

import std.traits;
import std.typetuple;

public import vibrant.ext.dquery.attribute;
public import vibrant.ext.dquery.attributes;
public import vibrant.ext.dquery.element;
public import vibrant.ext.dquery.helper;
public import vibrant.ext.dquery.overload;
public import vibrant.ext.dquery.query;

/++
 + Produces a query over the given type.
 +
 + Returns:
 +     A query over the supplied type.
 ++/
auto query(QueryType, bool Safe = false)()
{
	template MapToElement(string Name)
	{
		// Check for functions; each overload is kept as an element.
		static if(is(typeof(GetMember!(QueryType, Name)) == function))
		{
			alias MapToOverload(alias Overload) = Alias!(
				DQueryElement!(
					QueryType, Name, DQueryOverload!(
						arity!Overload, ReturnType!Overload, ParameterTypeTuple!Overload
					)()
				)()
			);

			alias MapToElement = staticMap!(
				MapToOverload, __traits(getOverloads, QueryType, Name)
			);
		}
		// Normal members.
		else
		{
			alias MapToElement = Alias!(DQueryElement!(QueryType, Name)());
		}
	}

	template SafeMap(string Name)
	{
		static if(__traits(compiles, MapToElement!Name) || Safe)
		{
			alias SafeMap = MapToElement!Name;
		}
		else
		{
			alias SafeMap = TypeTuple!();
		}
	}

	enum Elements = __traits(allMembers, QueryType);
	return DQuery!(QueryType, staticMap!(SafeMap, Elements))();
}

/++
 + Produces a query over the type of the supplied parameter.
 +
 + Params:
 +     value = A parameter to type query.
 +
 + Returns:
 +     A query over the parameter's type.
 ++/
auto query(QueryType)(QueryType value)
{
	return query!QueryType;
}

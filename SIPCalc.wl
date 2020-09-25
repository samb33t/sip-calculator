(* ::Package:: *)

(* ::Title:: *)
(*SIP Calculator*)


(*
	Package name: SIP Calculator
	Author: Soumya Sambeet Mohapatra
	Date created: September 25, 2020
*)


(* ::Section:: *)
(*Package headers*)


BeginPackage["SIPCalc`"]


(* ::Section:: *)
(*Function definitions*)


(* ::Subsection:: *)
(*Calculate SIP*)


calculateSIP[sipAmount_, years_, interest_] := Module[
	{balances, investments = sipAmount},
	investments = Flatten[{investments, Table[investments += sipAmount, years*12-1]}];
	balances = N[sipAmount + sipAmount * (interest/1200)];
	balances = IntegerPart[Flatten[{balances, Table[balances = N[balances + sipAmount + (balances + sipAmount) * (interest/1200)], {years*12-1}]}]];
	{investments,balances}
]


(* ::Subsection:: *)
(*PlotSIP*)


plotSIP[data_List] := 
	ListLinePlot[
		data,
		AxesLabel -> {Style["Months", Bold], Style["Amount", Bold]},
		PlotLabel -> Style["Investment V/S Return", Bold],
		PlotRange -> All,
		Ticks -> {Automatic, {#, IntegerPart[#]}& /@ Range[0, Last[data[[2]]], Last[data[[2]]]/5]},
		ImageSize -> {760, 580}
	]


(* ::Subsection:: *)
(*User interface*)


interface[] := DynamicModule[
	{sip,years,interest,data,finalValue,plot},
	plot = Style[
			"This app calculates the maturity value of an SIP mutual fund. 
			Please enter the SIP amount, Number of years of investment and expected rate of return to get the final values and the comparison grpah.",
			Italic
		];
	Column[{
		(* User input Form *)
		Grid[{
			{Text["SIP Amount (INR)"], InputField[Dynamic[sip], Number, FieldSize -> {13,1}, ContinuousAction -> True]},
			{Text["Duration (Years)"], InputField[Dynamic[years], Number, FieldSize -> {13,1}, ContinuousAction -> True]},
			{Text["Rate of Interest"], InputField[Dynamic[interest], Number, FieldSize -> {13,1}, ContinuousAction -> True]},
			{Button[
				Text["Final Value (INR)"],
				data = calculateSIP[sip, years, interest];
				finalValue = Last[data[[2]]];
				plot = plotSIP[data],
				Enabled -> Dynamic[NumberQ[sip] && NumberQ[years] && NumberQ[interest]]
			],
			InputField[Dynamic[finalValue], Number, FieldSize->{13,1}, Enabled->False]}
		}],
		(* Plot area *)
		Pane[
			Dynamic[plot],
			{800,600},
			BaseStyle->Background-> White
		]
	}]
]


(* ::Section:: *)
(*Package Footer*)


EndPackage[]

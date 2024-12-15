#use "project2.ml";;
#load "str.cma";;
#use "project2_driver.ml";;

let () = 
  let result = satisfyFromString "( a OR b )" in
  printSatis result
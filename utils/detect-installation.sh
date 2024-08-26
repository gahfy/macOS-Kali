#!/bin/sh

SOFTWARES_DIR="${SOFTWARES_DIR:-$HOME/.softwares}"

min_version=""
max_version=""

# compare_versions - Compare two software versions.
# 
# Usage: compare_versions version1 version2
# Returns:
#   0 if equal
#   1 if version1 > version2
#   2 if version1 < version2
#
# Example:
#   compare_versions "1.2.3" "1.2.4" -> 2
#   compare_versions "2.0" "1.9.9" -> 1
compare_versions () {
  version1=$1
  version2=$2
  IFS='.' read -ra version1_splitted <<< "$version1"
  IFS='.' read -ra version2_splitted <<< "$version2"
  for((index=0; index<${#version1_splitted[@]}; index+=1))
  do
    if [ -n "${version2}" ]; then
      if (( index < ${#version2_splitted[@]})); then
        if (( 10#${version1_splitted[index]} > 10#${version2_splitted[index]})); then
          return 1
        fi
        if (( 10#${version1_splitted[index]} < 10#${version2_splitted[index]})); then
          return 2
        fi
      else
        return 1
      fi
    else
      return 1
    fi
  done

  if (( ${#version1_splitted[@]} == ${#version2_splitted[@]} )); then
    return 0
  fi
  return 2
}


## Reading arguments
for arg in "$@"; do
  case $arg in
    min=*)
      min_version="${arg#min=}"
      shift
      ;;
    max=*)
      max_version="${arg#max=}"
      shift
      ;;
    excl_min=*)
      excl_min="${arg#excl_min=}"
      shift
      ;;
    excl_max=*)
      excl_max="${arg#excl_max=}"
      shift
      ;;
    *)
      program_name="$arg"
      ;;
  esac
done

if [ -z "$program_name" ]; then
  echo "Usage: $0 <program_name> [min=<min_version>] [max=<max_version>] [excl_min=<anything_for_true>] [excl_max=<anything_for_true>]"
  exit 1
fi

if [ -z "$excl_min" ]; then
  excl_min=0
else
  excl_min=1
fi
if [ -z "$excl_max" ]; then
  excl_max=0
else
  excl_max=1
fi

base_dir="$SOFTWARES_DIR/build"
shopt -s nullglob
  array=($base_dir/$program_name-*/)
shopt -u nullglob
length_to_cut=$((31 + ${#program_name} + 1))

versions=()

for dir in "${array[@]}"
do
  version=$(echo "$dir" | cut -c$length_to_cut- | rev | cut -c2- | rev)
  versions=("${versions[@]}" $version)
done

if [ -n "${min_version}" ]; then
  IFS='.' read -ra min_splitted <<< "$min_version"
fi
if [ -n "${max_version}" ]; then
  IFS='.' read -ra max_splitted <<< "$max_version"
fi

final_versions=()

for version in "${versions[@]}"
do
  compare_versions $version $min_version
  compare_with_min=$?
  
  if [[ -n max_version ]]; then
    compare_with_max=2
  else
    compare_versions $version $max_version
    compare_with_max=$?
  fi

  if ((
    ((compare_with_min == 1 || (compare_with_min == 0 && excl_min == 0))) &&
    ((compare_with_max == 2 || (compare_with_max == 0 && excl_max == 0)))
  )); then
    final_versions=("${final_versions[@]}" $version)
  fi
done

if ((${#final_versions[@]} == 0)); then
  exit 1
fi

final_version=${final_versions[0]}
IFS='.' read -ra final_version_splitted <<< "$final_version"
for((index=1; index<${#final_versions[@]}; index+=1))
do
  version=${final_versions[index]}
  compare_versions $version $final_version
  if(($? == 1)); then
    final_version=$version
  fi
done
echo "$base_dir/$program_name-$final_version"
exit 0